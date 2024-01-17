using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace WPFMannsMoneyRegister.Data;
public class AppViewModel
{
    private static ApplicationDbContext _context = new();

    public AppViewModel()
    {
    }

    public static async Task<List<Entities.Account>> GetAllAccountsAsync()
    {
        var _accounts = await _context.Accounts
            .ToListAsync();

        return _accounts;
    }

    public static async Task<Entities.Settings> GetAllSettingsAsync()
    {
        Entities.Settings emptySettings = null;
        var settings = await _context.Settings.SingleOrDefaultAsync() ?? emptySettings;

        return settings;
    }

    public static async Task<List<Entities.Transaction>> GetAllTransactionsForAccountAsync(Guid accountId, DateTime startDate, DateTime endDate)
    {
        // Get all transactions from the account within the date range
        var _transactions = await _context.Transactions
            .Include(x => x.Categories)
            .Where(x => x.AccountId == accountId)
            .Where(x => x.CreatedOnUTC >= endDate)
            .Where(x => x.CreatedOnUTC <= startDate)
            .ToListAsync();

        // Make sure that pending and uncleared items are ALWAYS added regardless of date, so we don't accidentally leave something sitting out and it's date goes way past a normal search
        // For example, we don't want an uncashed check that's 60 days old forgotten, not cleared, and now shown.
        var pendingAndClearedTransactions = await _context.Transactions
            .Include(x => x.Categories)
            .Where(x => x.AccountId == accountId)
            .Where(x => x.TransactionPendingUTC == null || x.TransactionClearedUTC == null)
            .ToListAsync();

        // Merge the two lists
        List<Entities.Transaction> returnList = _transactions.Concat(pendingAndClearedTransactions).Distinct()
            .OrderByDescending(x => x.TransactionClearedUTC == null && x.TransactionPendingUTC != null)
            .ThenByDescending(x => x.TransactionPendingUTC == null && x.TransactionClearedUTC == null)
            .ThenByDescending(x => x.CreatedOnUTC)
            .ToList();

        return returnList;
    }

    public static async Task UpdateTransaction(Entities.Transaction _transaction)
    {
        _context.Attach(_transaction);
        await _context.SaveChangesAsync();
    }
}
