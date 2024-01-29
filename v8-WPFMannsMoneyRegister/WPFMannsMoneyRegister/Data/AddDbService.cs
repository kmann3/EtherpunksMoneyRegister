using Microsoft.EntityFrameworkCore;
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Data;
public class AddDbService
{
    private static ApplicationDbContext _context = new();

    public AddDbService()
    {
    }

    public static async void LoadDatabase(string fileName)
    {
        ApplicationDbContext.DatabaseLocation = fileName;
        await _context.DisposeAsync(); // I don't know if I need to do this
        _context = new();
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

    public static async Task UpdateTransaction(AccountTransaction _transaction)
    {
        _context.Attach(_transaction);
        await _context.SaveChangesAsync();
    }
}
