using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Data;
public class AppDbService
{
    private static ApplicationDbContext _context = new();

    public AppDbService()
    {
    }

    /// <summary>
    /// Creates a new transaction for an account
    /// </summary>
    /// <param name="transaction">The new transaction to create</param>
    /// <remarks>This method is not currently tested.</remarks>
    public static async Task CreateNewTransactionAsync(AccountTransaction transaction)
    {
        Account account = await _context.Accounts.Where(x => x.Id == transaction.Id).SingleAsync();
        transaction.VerifySignage();
        transaction.Balance = account.CurrentBalance + transaction.Amount;
        account.CurrentBalance = transaction.Balance;
        //account.CurrentBalance = transaction.Balance;
        //if (transaction.TransactionPendingUTC == null || transaction.TransactionClearedUTC == null)
        //{
        //    account.OutstandingBalance += transaction.Amount;
        //    account.OutstandingItemCount++;
        //}

        //_context.Add(transaction);
        //await _context.SaveChangesAsync();

        throw new NotImplementedException();
    }

    public static async Task DeleteAccountAsync(Account account)
    {
        // Delete transaction files
        // delete transactions
        // delete account

        throw new NotImplementedException();
    }

    public static async Task DeleteTransactionAsync(AccountTransaction transaction)
    {
        Account account = await _context.Accounts.Where(x => x.Id == transaction.Id).SingleAsync();
        // Update account balance
        account.CurrentBalance -= transaction.Amount;

        // Check to see if it's outstanding, and if it is remove it from calculations
        if (transaction.TransactionClearedUTC == null)
        {
            account.OutstandingItemCount--;
            account.OutstandingBalance -= transaction.Amount;
        }

        // Figure out the new balance of items newer going forward
        var itemsToUpdate = await _context.AccountTransactions
            .Where(x => x.CreatedOnUTC >= transaction.CreatedOnUTC)
            .Where(x => x.AccountId == transaction.AccountId)
            .Where(x => x.Id != transaction.Id)
            .ToListAsync();

        foreach (var item in itemsToUpdate)
        {
            item.Balance -= transaction.Amount;
        }

        _context.Remove(transaction);

        await _context.SaveChangesAsync();
    }

    public static async Task<Account> GetAccountAsync(Guid id)
    {
        return await _context.Accounts.Where(x => x.Id == id).SingleAsync();
    }

    public static async Task<List<Account>> GetAllAccountsAsync()
    {
        List<Account> _accounts = await _context.Accounts
            .ToListAsync();

        return _accounts;
    }

    public static async Task<List<Category>> GetAllCategoriesAsync()
    {
        List<Category> _categories = await _context.Categories
            .OrderBy(x => x.Name)
            .ToListAsync();

        return _categories;
    }

    public static async Task<List<RecurringTransaction>> GetAllRecurringTransactionsAsync()
    {
        return await _context.RecurringTransactions.ToListAsync();
    }

    public static async Task<Settings> GetAllSettingsAsync()
    {
        Entities.Settings emptySettings = null;
        Settings? settings = await _context.Settings.SingleOrDefaultAsync() ?? emptySettings;

        return settings;
    }

    public static async Task<List<AccountTransaction>> GetAllTransactionsForAccountAsync(Guid accountId, DateTime startDate, DateTime endDate)
    {
        // Get all transactions from the account within the date range
        List<AccountTransaction> _transactions = await _context.AccountTransactions
            .Include(x => x.Categories)
            .Where(x => x.AccountId == accountId)
            .Where(x => x.CreatedOnUTC >= endDate)
            .Where(x => x.CreatedOnUTC <= startDate)
            .ToListAsync();

        // Make sure that pending and uncleared items are ALWAYS added regardless of date, so we don't accidentally leave something sitting out and it's date goes way past a normal search
        // For example, we don't want an uncashed check that's 60 days old forgotten, not cleared, and now shown.
        List<AccountTransaction> pendingAndClearedTransactions = await _context.AccountTransactions
            .Include(x => x.Categories)
            .Where(x => x.AccountId == accountId)
            .Where(x => x.TransactionPendingUTC == null || x.TransactionClearedUTC == null)
            .ToListAsync();

        // Merge the two lists
        List<AccountTransaction> returnList = [.. _transactions.Concat(pendingAndClearedTransactions).Distinct()
            .OrderByDescending(x => x.TransactionClearedUTC == null && x.TransactionPendingUTC != null)
            .ThenByDescending(x => x.TransactionPendingUTC == null && x.TransactionClearedUTC == null)
            .ThenByDescending(x => x.CreatedOnUTC)];

        return returnList;
    }

    public static async Task<AccountTransaction> GetTransactionAsync(Guid transactionId)
    {
        AccountTransaction transaction = await _context.AccountTransactions
            .Include(x => x.Categories)
            .Include(x => x.Files)
            .Where(x => x.Id == transactionId)
            .SingleAsync();

        return transaction;
    }

    public static async void LoadDatabaseAsync(string fileName)
    {
        ApplicationDbContext.DatabaseLocation = fileName;
        await _context.DisposeAsync(); // I don't know if I need to do this
        _context = new();
    }

    /// <summary>
    /// Recalculates the balance of all transactions and pending account information.
    /// This should really only be used in very rare situations such as manually messing with the database.
    /// The starting balance is where everything starts from - so that is required to be correct.
    /// </summary>
    /// <param name="account">The guid of the account to re-balance.</param>
    public static async Task RecalculateAccountAsync(Account account)
    {
        List<AccountTransaction> accountTransactions = await _context.AccountTransactions.Where(x => x.AccountId == account.Id).ToListAsync();
        decimal balance = account.StartingBalance;
        int outstandingCount = 0;
        decimal outstandingBalance = 0M;

        accountTransactions = [.. accountTransactions.OrderBy(x => x.CreatedOnUTC)];


        foreach (AccountTransaction? transaction in accountTransactions)
        {
            transaction.Balance = balance + transaction.Amount;
            balance = transaction.Balance;

            if (transaction.TransactionClearedUTC == null)
            {
                outstandingCount++;
                outstandingBalance += transaction.Amount;
            }
        }

        account.CurrentBalance = balance;
        account.OutstandingBalance = outstandingBalance;
        account.OutstandingItemCount = outstandingCount;

        await _context.SaveChangesAsync();
    }

    public async Task ReserveTransactionsAsync(List<RecurringTransaction> transactionsToReserve, Account accountToReserveFrom)
    {
        foreach (var bill in transactionsToReserve)
        {
            AccountTransaction reserveTransaction = new()
            {
                Name = bill.Name,
                Amount = bill.Amount,
                AccountId = accountToReserveFrom.Id,
                Categories = bill.Categories,
                TransactionType = bill.TransactionType,
                RecurringTransaction = bill
            };

            reserveTransaction.VerifySignage();

            accountToReserveFrom.CurrentBalance += bill.Amount;
            accountToReserveFrom.OutstandingBalance += bill.Amount;
            accountToReserveFrom.OutstandingItemCount++;
            reserveTransaction.Balance = accountToReserveFrom.CurrentBalance;

            if (bill.NextDueDate != null)
            {
                reserveTransaction.Notes = $"Expected due date: {bill.NextDueDate.Value.ToShortDateString()}";
            }

            bill.BumpNextDueDate();

            _context.AccountTransactions.Add(reserveTransaction);
        }

        await _context.SaveChangesAsync();
    }

    public static async Task UpdateTransactionAsync(AccountTransaction transaction, AccountTransaction previousTransaction)
    {
        ArgumentNullException.ThrowIfNull(transaction);
        ArgumentNullException.ThrowIfNull(previousTransaction);

        Trace.WriteLine(_context.Entry(transaction).State);

        Account account = await _context.Accounts.Where(x => x.Id == transaction.AccountId).SingleAsync();
        Account previousAccount = await _context.Accounts.Where(x => x.Id == previousTransaction.AccountId).SingleAsync();

        if(transaction.AccountId != previousTransaction.AccountId)
        {
            // We save the changes so the account ID's swap
            _context.Attach(transaction);
            await _context.SaveChangesAsync();

            // We recalculate both accounts because I don't intelligently track outstanding items. Surely there's a better / smarter way for this.
            await RecalculateAccountAsync(account);
            await RecalculateAccountAsync(previousAccount);
            return;
        }

        transaction.VerifySignage();
        
        // Check to see if outstanding balances need to change.
        // If it wasn't cleared then and it HAS cleared now - then we need to update outstanding balance.
        if (!previousTransaction!.TransactionClearedUTC.HasValue && transaction.TransactionClearedUTC.HasValue)
        {
            // Item cleared
            account.OutstandingItemCount--;
            account.OutstandingBalance -= transaction.Amount;
        }
        else if (previousTransaction.TransactionClearedUTC.HasValue && !transaction.TransactionClearedUTC.HasValue)
        {
            // Item was previously cleared but now is not.
            account.OutstandingItemCount++;
            account.OutstandingBalance += transaction.Amount;
        }

        // If the amount didn't change, the check to see if we need to update outstanding balance.
        // Update as needed then return. We do not need to update balances.
        if (previousTransaction.Amount == transaction.Amount)
        {
            // Possible other values changes but no further transaction modifications necessary
            await _context.SaveChangesAsync();
        }
        else
        {
            var itemsToUpdate = await _context.AccountTransactions
            .Where(x => x.CreatedOnUTC >= transaction.CreatedOnUTC)
            .Where(x => x.AccountId == transaction.AccountId)
            .Where(x => x.Id != transaction.Id)
            .ToListAsync();

            foreach (var item in itemsToUpdate)
            {
                item.Balance -= previousTransaction.Amount - transaction.Amount;
            }

            if (!transaction.TransactionClearedUTC.HasValue)
            {
                account.OutstandingBalance -= previousTransaction.Amount - transaction.Amount;
            }

            account.CurrentBalance -= previousTransaction.Amount - transaction.Amount;

            await _context.SaveChangesAsync();
        }
    }
}
