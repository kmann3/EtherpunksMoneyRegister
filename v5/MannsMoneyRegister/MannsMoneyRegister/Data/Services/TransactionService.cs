namespace MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using System.Reflection.Metadata;

public class TransactionService
{
    private ApplicationDbContext dbContext;

    public TransactionService(ApplicationDbContext dbContext)
    {
        this.dbContext = dbContext;
    }

    public async Task<List<Transaction>> GetAllTransactions(Account account)
    {
        var allTransactions = await dbContext.Transactions.Where(x => x.AccountId == account.Id).OrderByDescending(x => x.CreatedOnUTC).ToListAsync();

        return allTransactions;
    }
    
    public async Task CreateNewTransactionAsync(Account account, Transaction transaction)
    {
        // Make sure the amounts are positive/negative accordingly.
        switch (transaction.TransactionType)
        {
            case Transaction.EntryType.Credit:
                transaction.Amount = (Math.Abs(transaction.Amount));
                break;
            case Transaction.EntryType.Debit:
                transaction.Amount = -(Math.Abs(transaction.Amount));
                break;
        }

        transaction.Balance = account.CurrentBalance + transaction.Amount;
        account.CurrentBalance = transaction.Balance;
        if (transaction.TransactionPendingUTC == null || transaction.TransactionClearedUTC == null)
        {
            account.OutstandingBalance += transaction.Amount;
            account.OutstandingItemCount++;
        }

        dbContext.Add(transaction);
        await dbContext.SaveChangesAsync();
    }

    public async Task UpdateTransactionAsync(Account account, Transaction transaction)
    {
        Transaction oldTransaction = dbContext.Entry(transaction).OriginalValues.ToObject() as Transaction;

        // Check to see if outstanding balances need to change.
        if (!oldTransaction.TransactionClearedUTC.HasValue && transaction.TransactionClearedUTC.HasValue)
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
            await dbContext.SaveChangesAsync();
        } else
        {
            var itemsToUpdate = await dbContext.Transactions
            .Where(x => x.CreatedOnUTC >= transaction.CreatedOnUTC)
            .Where(x => x.AccountId == transaction.AccountId)
            .Where(x => x.DeletedOnUTC == null)
            .Where(x => x.Id != transaction.Id)
            .ToListAsync();


            foreach (var item in itemsToUpdate)
            {
                item.Balance -= (oldTransaction.Amount - transaction.Amount);
            }

            if(!transaction.TransactionClearedUTC.HasValue)
            {
                account.OutstandingBalance -= (oldTransaction.Amount - transaction.Amount);
            }

            account.CurrentBalance -= (oldTransaction.Amount - transaction.Amount);

            await dbContext.SaveChangesAsync();
        }
    }

    public async Task DeleteTransactionAsync(Account account, Transaction transaction, bool isTrueDelete = false)
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
        var itemsToUpdate = await dbContext.Transactions
            .Where(x => x.CreatedOnUTC >= transaction.CreatedOnUTC)
            .Where(x => x.AccountId == transaction.AccountId)
            .Where(x => x.DeletedOnUTC == null)
            .Where(x => x.Id != transaction.Id)
            .ToListAsync();

        foreach (var item in itemsToUpdate)
        {
            item.Balance -= transaction.Amount;
        }

        if (isTrueDelete)
        {
            dbContext.Remove(transaction);
        }

        await dbContext.SaveChangesAsync();
    }
}
