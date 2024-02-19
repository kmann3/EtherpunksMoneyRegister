using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore;
using System.Configuration;
using System.Diagnostics;
using System.IO;

namespace MannsMoneyRegister.Data;

public static class AppService
{
    private static List<Account> _accountList = new();

    private static List<Tag>? _allTags = null;

    private static ApplicationDbContext _context = new();

    private static string _databaseLocation = "";

    private static Guid? _defaultAccountId = null;

    private static string _defaultSearchDayCount = "";

    private static DateTime _defaultSearchDayCustomEnd = DateTime.MinValue;

    private static DateTime _defaultSearchDayCustomStart = DateTime.MinValue;

    private static Account _loadedAccount = new();

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
        if (_defaultSearchDayCount == "")
        {
            _defaultSearchDayCount = "45 Days";
            SaveConfigValue("DefaultSearchDayCount", _defaultSearchDayCount);
        }

        string[] dayOptions = ["30 Days", "45 Days", "60 Days", "90 Days", "Custom"];
        if (!dayOptions.Any(x => x.Equals(_defaultSearchDayCount)))
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

    public static Account Account
    {
        get => _loadedAccount;
        set => _loadedAccount = value;
    }

    public static List<Account> AccountList
    {
        get
        {
            _accountList = [.. _context.Accounts.OrderBy(x => x.Name)];
            return _accountList;
        }
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

    public static async Task CloseFileAsync()
    {
        await _context.DisposeAsync();
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

        await ReloadAllTagsAsync();
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

        if (setAsDefaultDatabase)
        {
            _databaseLocation = fileName;
            SaveConfigValue("DatabaseLocation", fileName);
        }
    }

    public static async Task<AccountTransaction> MarkTransactionAsClearedAsync(AccountTransaction transaction)
    {
        transaction.TransactionClearedUTC = DateTime.UtcNow;
        Account accountToUpdate = transaction.Account;
        accountToUpdate.OutstandingItemCount--;
        accountToUpdate.OutstandingBalance -= transaction.Amount;

        await _context.SaveChangesAsync();

        return transaction;
    }

    public static async Task<AccountTransaction> MarkTransactionAsPendingAsync(AccountTransaction transaction)
    {
        transaction.TransactionPendingUTC = DateTime.UtcNow;
        await _context.SaveChangesAsync();

        return transaction;
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

    public static async Task ReloadAllTagsAsync()
    {
        _allTags = await _context.Tags.OrderBy(x => x.Name).ToListAsync();
    }

    public static async Task<Tuple<Account, AccountTransaction>> SaveTransactionAsync(AccountTransaction transaction, bool isNew, AccountTransaction previousTransaction)
    {
        if (isNew)
        {
            return await CreateTransactionAsync(transaction);
        }
        else
        {
            return await UpdateTransactionAsync(transaction, previousTransaction);
        }
    }

    private static async Task<Tuple<Account, AccountTransaction>> CreateTransactionAsync(AccountTransaction transaction)
    {
        Account account = await _context.Accounts.Where(x => x.Id == transaction.Id).SingleAsync();
        transaction.VerifySignage();
        transaction.Balance = account.CurrentBalance + transaction.Amount;
        account.CurrentBalance = transaction.Balance;
        if (transaction.TransactionClearedUTC == null)
        {
            account.OutstandingBalance += transaction.Amount;
            account.OutstandingItemCount++;
        }

        _context.Add(transaction);
        await _context.SaveChangesAsync();
        _loadedAccount = account;

        return Tuple.Create(account, transaction);
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

    private static async Task<Tuple<Account, AccountTransaction>> UpdateTransactionAsync(AccountTransaction transaction, AccountTransaction previousTransaction)
    {
        ArgumentNullException.ThrowIfNull(transaction);
        ArgumentNullException.ThrowIfNull(previousTransaction);

        Account account = await _context.Accounts.Where(x => x.Id == transaction.AccountId).SingleAsync();
        Account previousAccount = await _context.Accounts.Where(x => x.Id == previousTransaction.AccountId).SingleAsync();

        if (transaction.AccountId != previousTransaction.AccountId)
        {
            // We save the changes so the account ID's swap
            _context.Attach(transaction);
            await _context.SaveChangesAsync();

            // We recalculate both accounts because I don't intelligently track outstanding items. Surely there's a better / smarter way for this.
            await RecalculateAccountAsync(account);
            await RecalculateAccountAsync(previousAccount);
            _loadedAccount = account;
            return Tuple.Create(account, transaction);
        }

        // Fix tags so we don't mess up unique constraints
        foreach (Tag tag in transaction.Tags)
        {
            if (_context.Tags.Entry(tag).State == EntityState.Detached)
            {
                _context.Tags.Attach(tag);
            }
        }

        // Fix files so we don't mess up unique constraints
        foreach (AccountTransactionFile file in transaction.Files)
        {
            if (_context.AccountTransactionFiles.Entry(file).State == EntityState.Detached)
            {
                await _context.AccountTransactionFiles.AddAsync(file);
            }
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

        // Update as needed then return. We do not need to update balances.
        if (previousTransaction.Amount != transaction.Amount)
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

            // TBI TEST THIS OUT
            account.CurrentBalance -= previousTransaction.Amount - transaction.Amount;
            transaction.Balance = account.CurrentBalance;
        }
        try
        {
            await _context.SaveChangesAsync();
            _loadedAccount = account;
        }
        catch (Exception ex)
        {
            Trace.WriteLine(ex);
        }

        return Tuple.Create(account, transaction);
    }
}