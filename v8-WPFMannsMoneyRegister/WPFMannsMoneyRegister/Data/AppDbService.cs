using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using System.Security.Principal;
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Data;
public class AppDbService
{
    private static ApplicationDbContext _context = new();

    public AppDbService()
    {
    }

    public static async Task CreateNewTransactionAsync(AccountTransaction transaction)
    {
        //// If there was an account change then we need to update two accounts balances accordingly.
        //transaction.VerifySignage();
        //transaction.Balance = account.CurrentBalance + transaction.Amount;
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

    public static async Task DeleteAccountAsync()
    {
        
        throw new NotImplementedException();
    }

    public static async Task DeleteTransactionAsync()
    {
        //// Update account balance
        //account.CurrentBalance -= transaction.Amount;

        //// Check to see if it's outstanding, and if it is remove it from calculations
        //if (transaction.TransactionClearedUTC == null)
        //{
        //    account.OutstandingItemCount--;
        //    account.OutstandingBalance -= transaction.Amount;
        //}

        //// Figure out the new balance of items newer going forward
        //var itemsToUpdate = await _context.Transactions
        //    .Where(x => x.CreatedOnUTC >= transaction.CreatedOnUTC)
        //    .Where(x => x.AccountId == transaction.AccountId)
        //    .Where(x => x.DeletedOnUTC == null)
        //    .Where(x => x.Id != transaction.Id)
        //    .ToListAsync();

        //foreach (var item in itemsToUpdate)
        //{
        //    item.Balance -= transaction.Amount;
        //}

        //_context.Remove(transaction);

        //await _context.SaveChangesAsync();
        throw new NotImplementedException();
    }

    public static async Task<List<Account>> GetAllAccountsAsync()
    {
        var _accounts = await _context.Accounts
            .ToListAsync();

        return _accounts;
    }

    public static async Task<List<Category>> GetAllCategoriesAsync()
    {
        var _categories = await _context.Categories
            .OrderBy(x => x.Name)
            .ToListAsync();

        return _categories;
    }

    public static async Task<Settings> GetAllSettingsAsync()
    {
        Entities.Settings emptySettings = null;
        var settings = await _context.Settings.SingleOrDefaultAsync() ?? emptySettings;

        return settings;
    }

    public static async Task<List<AccountTransaction>> GetAllTransactionsForAccountAsync(Guid accountId, DateTime startDate, DateTime endDate)
    {
        // Get all transactions from the account within the date range
        var _transactions = await _context.AccountTransactions
            .Include(x => x.Categories)
            .Where(x => x.AccountId == accountId)
            .Where(x => x.CreatedOnUTC >= endDate)
            .Where(x => x.CreatedOnUTC <= startDate)
            .ToListAsync();

        // Make sure that pending and uncleared items are ALWAYS added regardless of date, so we don't accidentally leave something sitting out and it's date goes way past a normal search
        // For example, we don't want an uncashed check that's 60 days old forgotten, not cleared, and now shown.
        var pendingAndClearedTransactions = await _context.AccountTransactions
            .Include(x => x.Categories)
            .Where(x => x.AccountId == accountId)
            .Where(x => x.TransactionPendingUTC == null || x.TransactionClearedUTC == null)
            .ToListAsync();

        // Merge the two lists
        List<AccountTransaction> returnList = _transactions.Concat(pendingAndClearedTransactions).Distinct()
            .OrderByDescending(x => x.TransactionClearedUTC == null && x.TransactionPendingUTC != null)
            .ThenByDescending(x => x.TransactionPendingUTC == null && x.TransactionClearedUTC == null)
            .ThenByDescending(x => x.CreatedOnUTC)
            .ToList();

        return returnList;
    }

    public static async Task<AccountTransaction> GetTransactionAsync(Guid transactionId)
    {
        var transaction = await _context.AccountTransactions
            .Include(x => x.Categories)
            .Include( x=> x.Files)
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
        var accountTransactions = _context.AccountTransactions.Where(x => x.AccountId == account.Id).ToList();

        decimal balance = account.StartingBalance;
        int outstandingCount = 0;
        decimal outstandingBalance = 0M;

        accountTransactions = accountTransactions.OrderBy(x => x.CreatedOnUTC).ToList();


        foreach (var transaction in accountTransactions)
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

    public async Task ReserveTransactionsAsync(List<RecurringTransaction> transactionsToReserve)
    {
        //foreach (var bill in transactionsToReserve)
        //{
        //    Transaction reserveTransaction = new()
        //    {
        //        Name = bill.Name,
        //        Amount = bill.Amount,
        //        Account = accountToReserveFrom,
        //        Categories = bill.Categories,
        //        TransactionType = bill.TransactionType,
        //        RecurringTransaction = bill
        //    };

        //    reserveTransaction.VerifySignage();

        //    accountToReserveFrom.CurrentBalance += bill.Amount;
        //    accountToReserveFrom.OutstandingBalance += bill.Amount;
        //    accountToReserveFrom.OutstandingItemCount++;
        //    reserveTransaction.Balance = accountToReserveFrom.CurrentBalance;

        //    if (bill.NextDueDate != null)
        //    {
        //        reserveTransaction.Notes = $"Expected due date: {bill.NextDueDate.Value.ToShortDateString()}";
        //    }

        //    bill.BumpNextDueDate();

        //    _context.Transactions.Add(reserveTransaction);
        //}

        //await _context.SaveChangesAsync();
        throw new NotImplementedException();
    }

    public static async Task UpdateTransactionAsync(AccountTransaction _transaction)
    {
        Trace.WriteLine(_context.Entry(_transaction).State);

        //ArgumentNullException.ThrowIfNull(account);
        //ArgumentNullException.ThrowIfNull(transaction);

        //Transaction oldTransaction = (Transaction)_context.Entry(transaction!).OriginalValues.ToObject();
        //transaction.VerifySignage();

        //// Check to see if outstanding balances need to change.
        //// If it wasn't cleared then and it HAS cleared now - then we need to update outstanding balance.
        //if (!oldTransaction!.TransactionClearedUTC.HasValue && transaction.TransactionClearedUTC.HasValue)
        //{
        //    // Item cleared
        //    account.OutstandingItemCount--;
        //    account.OutstandingBalance -= transaction.Amount;
        //}
        //else if (oldTransaction.TransactionClearedUTC.HasValue && !transaction.TransactionClearedUTC.HasValue)
        //{
        //    // Item was previously cleared but now is not.
        //    account.OutstandingItemCount++;
        //    account.OutstandingBalance += transaction.Amount;
        //}

        //// If the amount didn't change, the check to see if we need to update outstanding balance.
        //// Update as needed then return. We do not need to update balances.
        //if (oldTransaction.Amount == transaction.Amount)
        //{
        //    // Possible other values changes but no further transaction modifications necessary
        //    await _context.SaveChangesAsync();
        //}
        //else
        //{
        //    var itemsToUpdate = await _context.Transactions
        //    .Where(x => x.CreatedOnUTC >= transaction.CreatedOnUTC)
        //    .Where(x => x.AccountId == transaction.AccountId)
        //    .Where(x => x.DeletedOnUTC == null)
        //    .Where(x => x.Id != transaction.Id)
        //    .ToListAsync();

        //    foreach (var item in itemsToUpdate)
        //    {
        //        item.Balance -= oldTransaction.Amount - transaction.Amount;
        //    }

        //    if (!transaction.TransactionClearedUTC.HasValue)
        //    {
        //        account.OutstandingBalance -= oldTransaction.Amount - transaction.Amount;
        //    }

        //    account.CurrentBalance -= oldTransaction.Amount - transaction.Amount;

        //    await _context.SaveChangesAsync();
        //}

        throw new NotImplementedException();
    }
}
