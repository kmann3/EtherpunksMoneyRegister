using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
namespace MoneyRegister.Data.Services;

public class TransactionService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public async Task CreateNewTransactionAsync(Account account, Transaction transaction)
    {

        //Make sure the amounts are positive/ negative accordingly.
        switch (transaction.TransactionTypeLookup.Name)
        {
            case "Credit":
                transaction.Amount = (Math.Abs(transaction.Amount));
                break;
            case "Debit":
                transaction.Amount = -(Math.Abs(transaction.Amount));
                break;
            default:
                throw new Exception($"Unknown transaction type: {transaction.TransactionTypeLookup.Name}");
        }

        transaction.Balance = account.CurrentBalance + transaction.Amount;
        account.CurrentBalance = transaction.Balance;
        if (transaction.TransactionPendingUTC == null || transaction.TransactionClearedUTC == null)
        {
            account.OutstandingBalance += transaction.Amount;
            account.OutstandingItemCount++;
        }

        _context.Add(transaction);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteTransactionAsync(Account account, Transaction transaction)
    {
        // Update account balance
        account.CurrentBalance -= transaction.Amount;

        // Check to see if it's outstanding, and if it is remove it from calculations
        if (transaction.TransactionClearedUTC == null)
        {
            account.OutstandingItemCount--;
            account.OutstandingBalance -= transaction.Amount;
        }

        // Figure out the new balance of items newer going forward
        var itemsToUpdate = await _context.Transactions
            .Where(x => x.CreatedOnUTC >= transaction.CreatedOnUTC)
            .Where(x => x.AccountId == transaction.AccountId)
            .Where(x => x.DeletedOnUTC == null)
            .Where(x => x.Id != transaction.Id)
            .ToListAsync();

        foreach (var item in itemsToUpdate)
        {
            item.Balance -= transaction.Amount;
        }

        _context.Remove(transaction);

        await _context.SaveChangesAsync();
    }

    public async Task UpdateTransactionAsync(Account account, Transaction transaction)
    {
        ArgumentNullException.ThrowIfNull(account);
        ArgumentNullException.ThrowIfNull(transaction);

        Transaction oldTransaction = (Transaction)_context.Entry(transaction!).OriginalValues.ToObject();

        // Check to see if outstanding balances need to change.
        if (oldTransaction!.TransactionClearedUTC.HasValue && transaction.TransactionClearedUTC.HasValue)
        {
            // Item cleared
            account.OutstandingItemCount--;
            account.OutstandingBalance -= transaction.Amount;
        }
        else if (oldTransaction.TransactionClearedUTC.HasValue && !transaction.TransactionClearedUTC.HasValue)
        {
            // Item was previously cleared but now is not.
            account.OutstandingItemCount++;
            account.OutstandingBalance += transaction.Amount;
        }

        // If the amount didn't change, the check to see if we need to update outstanding balance.
        // Update as needed then return. We do not need to update balances.
        if (oldTransaction.Amount == transaction.Amount)
        {
            // Possible other values changes but no further transaction modifications necessary
            await _context.SaveChangesAsync();
        }
        else
        {
            var itemsToUpdate = await _context.Transactions
            .Where(x => x.CreatedOnUTC >= transaction.CreatedOnUTC)
            .Where(x => x.AccountId == transaction.AccountId)
            .Where(x => x.DeletedOnUTC == null)
            .Where(x => x.Id != transaction.Id)
            .ToListAsync();


            foreach (var item in itemsToUpdate)
            {
                item.Balance -= (oldTransaction.Amount - transaction.Amount);
            }

            if (!transaction.TransactionClearedUTC.HasValue)
            {
                account.OutstandingBalance -= (oldTransaction.Amount - transaction.Amount);
            }

            account.CurrentBalance -= (oldTransaction.Amount - transaction.Amount);

            await _context.SaveChangesAsync();
        }
    }

    public async Task ReserveTransactionsAsync(List<RecurringTransaction> transactionsToReserve, Account accountToReserveFrom)
    {
        foreach (var bill in transactionsToReserve)
        {
            Transaction reserveTransaction = new()
            {
                Name = bill.Name,
                Amount = bill.Amount,
                Account = accountToReserveFrom,
                Categories = bill.Categories,
            };

            accountToReserveFrom.CurrentBalance += bill.Amount;
            accountToReserveFrom.OutstandingBalance += bill.Amount;
            accountToReserveFrom.OutstandingItemCount++;
            reserveTransaction.Balance = accountToReserveFrom.CurrentBalance;

            if (bill.NextDueDate != null)
            {
                reserveTransaction.Notes = $"Expected due date: {bill.NextDueDate.Value.ToShortDateString()}";
            }

            bill.BumpNextDueDate();

            _context.Transactions.Add(reserveTransaction);
        }

        await _context.SaveChangesAsync();
    }
}
