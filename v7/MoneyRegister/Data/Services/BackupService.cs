using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using System.IO.Compression;
using System.Text.Json;

namespace MoneyRegister.Data.Services;

public class BackupService(ApplicationDbContext context)
{
    private readonly ApplicationDbContext _context = context;

    public static readonly string AccountsJsonFileName                          = $"accounts.json";
    public static readonly string CategoriesJsonFileName                        = $"categories.json";
    public static readonly string FilesJsonFileName                             = $"files.json";
    public static readonly string RecurringTransactionsJsonFileName             = $"recurring_transactions.json";
    public static readonly string TransactionsJsonFileName                      = $"transactions.json";
    public static readonly string TransactionGroupsJsonFileName                 = $"transaction_groups.json";
    public static readonly string UsersJsonFileName                             = $"users.json";
    public static readonly string Link_category_transactionFileName             = $"link_category_transaction.json";
    public static readonly string Link_category_recurringTransactionFileName    = $"link_category_recurringTransaction.json";
    public static readonly string Lookup_RecurringTransactionFrequencyFileName  = $"lookup_RecurringTransactionFrequency.json";
    public static readonly string Lookup_TransactionTypeFileName                = $"lookup_TransactionType.json";

    public async Task<string> CreateBackupJsonAsync()
    {
        string fileName = $"backup-{DateTime.Now:yyyyMMdd.HHmmdd}";

        List<Account> accountList = await _context.Accounts.ToListAsync();
        List<ApplicationUser> userList = await _context.ApplicationUsers.ToListAsync();
        List<Category> categoryList = await _context.Categories.ToListAsync();
        List<Link_Category_Transaction> link_category_TransactionList = await _context.Link_Categories_Transactions.ToListAsync();
        List<Link_Category_RecurringTransaction> link_category_RecurringTransactionList = await _context.Link_Category_RecurringTransactions.ToListAsync();
        List<Lookup_RecurringTransactionFrequency> lookup_RecurringTransactionFrequencyList = await _context.Lookup_RecurringTransactionFrequencies.ToListAsync();
        List<Lookup_TransactionType> lookup_TransactionTypeList = await _context.Lookup_TransactionTypes.ToListAsync();
        List<RecurringTransaction> recurringTransactionList = await _context.RecurringTransactions.ToListAsync();
        List<Transaction> transactionList = await _context.Transactions.ToListAsync();
        List<TransactionFile> fileList = await _context.Files.ToListAsync();
        List<TransactionGroup> transactionGroupList = await _context.TransactionGroups.ToListAsync();

        var options = new JsonSerializerOptions { WriteIndented = true };
        string jsonString = string.Empty;

        Directory.CreateDirectory(fileName);
        try
        {
            jsonString = JsonSerializer.Serialize(accountList, options);
            File.WriteAllText($@"{fileName}/{AccountsJsonFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(categoryList, options);
            File.WriteAllText($@"{fileName}/{CategoriesJsonFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(fileList, options);
            File.WriteAllText($@"{fileName}/{FilesJsonFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(recurringTransactionList, options);
            File.WriteAllText($@"{fileName}/{RecurringTransactionsJsonFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(transactionList, options);
            File.WriteAllText($@"{fileName}/{TransactionsJsonFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(transactionGroupList, options);
            File.WriteAllText($@"{fileName}/{TransactionGroupsJsonFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(userList, options);
            File.WriteAllText($@"{fileName}/{UsersJsonFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(link_category_TransactionList, options);
            File.WriteAllText($@"{fileName}/{Link_category_transactionFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(link_category_RecurringTransactionList, options);
            File.WriteAllText($@"{fileName}/{Link_category_recurringTransactionFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(lookup_RecurringTransactionFrequencyList, options);
            File.WriteAllText($@"{fileName}/{Lookup_RecurringTransactionFrequencyFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(lookup_TransactionTypeList, options);
            File.WriteAllText($@"{fileName}/{Lookup_TransactionTypeFileName}", jsonString);

            ZipFile.CreateFromDirectory(fileName, fileName + ".zip");
        }
        finally
        {
            Directory.Delete(fileName, true);
        }

        return fileName + ".zip";
    }

    public async Task RestoreBackupJsonAsync(string fileName)
    {
        try
        {
            Console.WriteLine("Begin purge");

            if (!File.Exists(fileName)) throw new FileNotFoundException($"File not found: {fileName}");

            ZipFile.ExtractToDirectory(fileName, "restore");

            if (!File.Exists($"restore/{AccountsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{AccountsJsonFileName}");
            if (!File.Exists($"restore/{CategoriesJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{CategoriesJsonFileName}");
            if (!File.Exists($"restore/{RecurringTransactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{RecurringTransactionsJsonFileName}");
            if (!File.Exists($"restore/{TransactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{TransactionsJsonFileName}");
            if (!File.Exists($"restore/{TransactionGroupsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{TransactionGroupsJsonFileName}");
            if (!File.Exists($"restore/{UsersJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{UsersJsonFileName}");
            if (!File.Exists($"restore/{FilesJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{FilesJsonFileName}");
            if (!File.Exists($"restore/{Lookup_RecurringTransactionFrequencyFileName}")) throw new FileNotFoundException($"Json file not found: restore/{Lookup_RecurringTransactionFrequencyFileName}");
            if (!File.Exists($"restore/{Lookup_TransactionTypeFileName}")) throw new FileNotFoundException($"Json file not found: restore/{Lookup_TransactionTypeFileName}");

            if (!File.Exists($"restore/{Link_category_transactionFileName}")) throw new FileNotFoundException($"Json file not found: restore/{Link_category_transactionFileName}");

            if (!File.Exists($"restore/{Link_category_recurringTransactionFileName}")) throw new FileNotFoundException($"Json file not found: restore/{Link_category_recurringTransactionFileName}");

            _context.RemoveRange(await _context.Link_Categories_Transactions.ToListAsync());
            _context.RemoveRange(await _context.Link_Category_RecurringTransactions.ToListAsync());
            _context.RemoveRange(await _context.Accounts.ToListAsync());
            _context.RemoveRange(await _context.Categories.ToListAsync());
            _context.RemoveRange(await _context.Files.ToListAsync());
            _context.RemoveRange(await _context.RecurringTransactions.ToListAsync());
            _context.RemoveRange(await _context.Transactions.ToListAsync());
            _context.RemoveRange(await _context.TransactionGroups.ToListAsync());
            _context.RemoveRange(await _context.ApplicationUsers.ToListAsync());
            _context.RemoveRange(await _context.Lookup_RecurringTransactionFrequencies.ToListAsync());
            _context.RemoveRange(await _context.Lookup_TransactionTypes.ToListAsync());

            Console.WriteLine("Database purged");

            await _context.SaveChangesAsync();

            string jsonString;

            var options = new JsonSerializerOptions { WriteIndented = true };

            Console.WriteLine("Begin restore");

            jsonString = await File.ReadAllTextAsync($"restore/{UsersJsonFileName}");
            List<ApplicationUser> users = JsonSerializer.Deserialize<List<ApplicationUser>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{UsersJsonFileName}");
            await _context.ApplicationUsers.AddRangeAsync(users);

            Console.WriteLine("Users restored");

            jsonString = await File.ReadAllTextAsync($"restore/{Lookup_RecurringTransactionFrequencyFileName}");
            List<Lookup_RecurringTransactionFrequency> recurringTransactionFrequencies = JsonSerializer.Deserialize<List<Lookup_RecurringTransactionFrequency>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{Lookup_RecurringTransactionFrequencyFileName}");
            await _context.Lookup_RecurringTransactionFrequencies.AddRangeAsync(recurringTransactionFrequencies);

            Console.WriteLine("Users restored");

            jsonString = await File.ReadAllTextAsync($"restore/{Lookup_TransactionTypeFileName}");
            List<Lookup_TransactionType> transactionTypes = JsonSerializer.Deserialize<List<Lookup_TransactionType>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{Lookup_TransactionTypeFileName}");
            await _context.Lookup_TransactionTypes.AddRangeAsync(transactionTypes);

            Console.WriteLine("Users restored");

            jsonString = await File.ReadAllTextAsync($"restore/{AccountsJsonFileName}");
            List<Account> accounts = JsonSerializer.Deserialize<List<Account>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{AccountsJsonFileName}");
            await _context.Accounts.AddRangeAsync(accounts);

            Console.WriteLine("Accounts restored");

            jsonString = await File.ReadAllTextAsync($"restore/{CategoriesJsonFileName}");
            List<Category> categories = JsonSerializer.Deserialize<List<Category>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{CategoriesJsonFileName}");
            await _context.Categories.AddRangeAsync(categories);

            Console.WriteLine("Categories restored");

            jsonString = await File.ReadAllTextAsync($"restore/{TransactionGroupsJsonFileName}");
            List<TransactionGroup> transactionGroups = JsonSerializer.Deserialize<List<TransactionGroup>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{TransactionGroupsJsonFileName}");
            await _context.TransactionGroups.AddRangeAsync(transactionGroups);

            Console.WriteLine("Transaction Groups restored");

            jsonString = await File.ReadAllTextAsync($"restore/{RecurringTransactionsJsonFileName}");
            List<RecurringTransaction> recurringTransactions = JsonSerializer.Deserialize<List<RecurringTransaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{RecurringTransactionsJsonFileName}");
            await _context.RecurringTransactions.AddRangeAsync(recurringTransactions);

            Console.WriteLine("Recurring Transactions restored");

            jsonString = await File.ReadAllTextAsync($"restore/{TransactionsJsonFileName}");
            List<Transaction> transactions = JsonSerializer.Deserialize<List<Transaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{TransactionGroupsJsonFileName}");
            await _context.Transactions.AddRangeAsync(transactions);

            Console.WriteLine("Transactions restored");

            jsonString = await File.ReadAllTextAsync($"restore/{TransactionsJsonFileName}");
            List<TransactionFile> transactionFiles = JsonSerializer.Deserialize<List<TransactionFile>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{FilesJsonFileName}");
            await _context.Files.AddRangeAsync(transactionFiles);

            Console.WriteLine("Transaction Files restored");

            jsonString = await File.ReadAllTextAsync($"restore/{Link_category_transactionFileName}");
            List<Link_Category_Transaction> link_category_Transaction = JsonSerializer.Deserialize<List<Link_Category_Transaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{Link_category_transactionFileName}");
            await _context.Link_Categories_Transactions.AddRangeAsync(link_category_Transaction);

            jsonString = await File.ReadAllTextAsync($"restore/{Link_category_recurringTransactionFileName}");
            List<Link_Category_RecurringTransaction> link_Category_RecurringTransactions = JsonSerializer.Deserialize<List<Link_Category_RecurringTransaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{Link_category_recurringTransactionFileName}");
            await _context.Link_Category_RecurringTransactions.AddRangeAsync(link_Category_RecurringTransactions);

            await _context.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }
        finally
        {
            File.Delete(fileName);
            Directory.Delete("restore", true);
        }
    }
}