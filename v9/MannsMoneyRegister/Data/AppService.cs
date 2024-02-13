using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows.Automation.Provider;

namespace MannsMoneyRegister.Data;

public static class AppService
{
    static AppService()
    {
        // Handle the database location

        _databaseLocation = ConfigurationManager.AppSettings["DatabaseLocation"] ?? "MMR.sqlite3";
        if (!File.Exists(_databaseLocation))
        {
            throw new FileNotFoundException("Cannot find database");
            throw new NotImplementedException("We should create an empty / new one");
        }

        // Handle default account
        if (Guid.TryParse(ConfigurationManager.AppSettings["DefaultAccountId"], out Guid id) == false)
        {
            // See if there are any accounts, if there are - pick the first one.
            throw new NotImplementedException();
        }
        else
        {
            _defaultAccountId = id;
        }

        // Handle search defaults

        _defaultSearchDayCount = ConfigurationManager.AppSettings["DefaultSearchDayCount"] ?? "";
        if(_defaultSearchDayCount == "")
        {
            _defaultSearchDayCount = "45 Days";
            SaveConfigValue("DefaultSearchDayCount", _defaultSearchDayCount);
        }

        string[] dayOptions = ["30 Days", "45 Days", "60 Days", "90 Days", "Custom"];
        if(!dayOptions.Any(x => x.Equals(_defaultSearchDayCount)))
        {
            _defaultSearchDayCount = "45 Days";
            SaveConfigValue("DefaultSearchDayCount", _defaultSearchDayCount);
        }

        if (DateTime.TryParse(ConfigurationManager.AppSettings["DefaultSearchDayCustomStart"], out DateTime start) == false)
        {
            _defaultSearchDayCustomStart = DateTime.UtcNow.AddDays(-45);
            SaveConfigValue("DefaultSearchDayCustomStart", _defaultSearchDayCustomStart.ToString());
        }
        else
        {
            _defaultSearchDayCustomStart = start;
        }

        if (DateTime.TryParse(ConfigurationManager.AppSettings["DefaultSearchDayCustomEnd"], out DateTime end) == false)
        {
            _defaultSearchDayCustomEnd = DateTime.UtcNow;
            SaveConfigValue("DefaultSearchDayCustomEnd", _defaultSearchDayCustomEnd.ToString());
        }
        else
        {
            _defaultSearchDayCustomEnd = end;
        }

    }

    public static async void Initialize()
    {
        ApplicationDbContext.DatabaseLocation = _databaseLocation;

        await _context.DisposeAsync(); // I don't know if I need to do this
        _context = new ApplicationDbContext() ?? throw new Exception("Cannot make a new database context.");

        if (_defaultAccountId.HasValue == true) _loadedAccount = await _context.Accounts.Where(x => x.Id == _defaultAccountId.Value).SingleOrDefaultAsync();
        if (_loadedAccount == null)
        {
            // account not found. Something went wrong.
            throw new NotImplementedException();
        }

        await ReloadAllTags();
    }

    private static List<Account> _accountList = new();
    private static ApplicationDbContext _context = new();
    private static Guid? _defaultAccountId = null;
    private static string _databaseLocation = "";
    private static string _defaultSearchDayCount = "";
    private static DateTime _defaultSearchDayCustomEnd = DateTime.MinValue;
    private static DateTime _defaultSearchDayCustomStart = DateTime.MinValue;
    private static List<Tag>? _allTags = null;

    private static Account _loadedAccount = new();

    public static List<Account> AccountList
    {
        get
        {
            _accountList = [.. _context.Accounts.OrderBy(x => x.Name)];
            return _accountList;
        }
    }

    public static Account Account
    {
        get => _loadedAccount;
        set => _loadedAccount = value;
    }

    public static List<Tag> AllTags
    {
        get
        {
            _allTags ??= _context.Tags.OrderBy(x => x.Name).ToList();

            return _allTags;
        }
    }

    public static string DefaultSearchDayCount
    {
        get => _defaultSearchDayCount!;
        set => _defaultSearchDayCount = value;
    }

    public static DateTime DefaultSearchDayCustomEnd
    {
        get => _defaultSearchDayCustomEnd;
        set
        {
            SaveConfigValue("DefaultSearchDayCustomEnd", _defaultSearchDayCustomEnd.ToString());
            _defaultSearchDayCustomEnd = value;
        }
    }

    public static DateTime DefaultSearchDayCustomStart
    {
        get => _defaultSearchDayCustomStart;
        set
        {
            SaveConfigValue("DefaultSearchDayCustomStart", _defaultSearchDayCustomStart.ToString());
            _defaultSearchDayCustomStart = value;
        }
    }

    public static async Task<List<AccountTransaction>> GetAccountTransactionsByDateRangeAsync(Guid accountId, DateTime startDate, DateTime endDate)
    {
        List<AccountTransaction> _transactions = await _context.AccountTransactions
        .Include(x => x.Tags)
        .Include(x => x.Files)
        .Where(x => x.AccountId == accountId)
        .Where(x => x.CreatedOnUTC <= endDate)
        .Where(x => x.CreatedOnUTC >= startDate)
        .ToListAsync();

        // Make sure that pending and uncleared items are ALWAYS added regardless of date, so we don't accidentally leave something sitting out and it's date goes way past a normal search
        // For example, we don't want an uncashed check that's 60 days old forgotten, not cleared, and now shown.
        List<AccountTransaction> pendingAndClearedTransactions = await _context.AccountTransactions
            .Include(x => x.Tags)
            .Include(x => x.Files)
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

    public static async Task<List<Tag>> GetAllTagsAsync()
    {
        return await _context.Tags.OrderBy(x => x.Name).ToListAsync();
    }

    public static async Task<Account> LoadAccountAsync(Guid id)
    {
        Account = await _context.Accounts.Where(x => x.Id == id).SingleAsync();
        return Account;
    }

    public static async Task LoadDatabaseAsync(string fileName, bool setAsDefaultDatabase = false)
    {
        if (String.IsNullOrEmpty(fileName)) fileName = _databaseLocation;
        if (!File.Exists(fileName)) throw new FileNotFoundException("Database not found");
        ApplicationDbContext.DatabaseLocation = fileName;
        await _context.DisposeAsync(); // I don't know if I need to do this
        _context = new();

        if(setAsDefaultDatabase)
        {
            _databaseLocation = fileName;
            SaveConfigValue("DatabaseLocation", fileName);
        }
    }

    public static async Task<AccountTransaction> MarkTransactionAsCleared(AccountTransaction transaction)
    {
        transaction.TransactionClearedUTC = DateTime.UtcNow;
        Account accountToUpdate = transaction.Account;
        accountToUpdate.OutstandingItemCount--;
        accountToUpdate.OutstandingBalance -= transaction.Amount;

        await _context.SaveChangesAsync();

        return transaction;
    }

    public static async Task<AccountTransaction> MarkTransactionAsPending(AccountTransaction transaction)
    {
        transaction.TransactionPendingUTC = DateTime.UtcNow;
        await _context.SaveChangesAsync();

        return transaction;
    }

    public static async Task ReloadAllTags()
    {
        _allTags = await _context.Tags.OrderBy(x => x.Name).ToListAsync();
    }

    private static void SaveConfigValue(string key, string value)
    {
        try
        {
            var configFile = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
            var settings = configFile.AppSettings.Settings;
            if (settings[key] == null)
            {
                settings.Add(key, value);
            }
            else
            {
                settings[key].Value = value;
            }
            configFile.Save(ConfigurationSaveMode.Modified);
            ConfigurationManager.RefreshSection(configFile.AppSettings.SectionInformation.Name);
        }
        catch (ConfigurationErrorsException ex)
        {
            Trace.WriteLine($"Error reading app.config? Error: {ex}");
        }
    }
}
