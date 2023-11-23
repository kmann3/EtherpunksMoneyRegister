using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using System.IO.Compression;
using System.Text.Json;

namespace MoneyRegister.Data.Services;

public class BackupService
{
    private ApplicationDbContext _dbContext;
    public static string accountsJsonFileName = $"accounts.json";
    public static string categoriesJsonFileName = $"categories.json";
    public static string filesJsonFileName = $"files.json";
    public static string recurringTransactionsJsonFileName = $"recurring_transactions.json";
    public static string transactionsJsonFileName = $"transactions.json";
    public static string transactionGroupsJsonFileName = $"transaction_groups.json";
    public static string usersJsonFileName = $"users.json";

    public BackupService(ApplicationDbContext _dbContext)
    {
        _dbContext = _dbContext;
    }

    public async Task<string> CreateBackupJsonAsync()
    {
        string fileName = $"backup-{DateTime.Now:yyyyMMdd.HHmmdd}";

        List<Account> accountList = await _dbContext.Accounts.ToListAsync();
        List<Category> categoryList = await _dbContext.Categories.ToListAsync();
//        List<TransactionFile> fileList = await _dbContext.Files.ToListAsync();
        List<RecurringTransaction> recurringTransactionList = await _dbContext.RecurringTransactions.ToListAsync();
        List<Transaction> transactionList = await _dbContext.Transactions.ToListAsync();
        List<TransactionGroup> transactionGroupList = await _dbContext.TransactionGroups.ToListAsync();
        List<ApplicationUser> userList = await _dbContext.ApplicationUsers.ToListAsync();

        var options = new JsonSerializerOptions { WriteIndented = true };
        string jsonString = string.Empty;

        Directory.CreateDirectory(fileName);

        jsonString = JsonSerializer.Serialize(accountList, options);
        File.WriteAllText($@"{fileName}/{accountsJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(categoryList, options);
        File.WriteAllText($@"{fileName}/{categoriesJsonFileName}", jsonString);

        //        // TODO: SAVE ACTUAL FILE DATA HERE
        //#if !DEBUG
        //throw new NotImplementedException("IMPLEMENT FILE SAVE DATA");
        //#endif

        jsonString = JsonSerializer.Serialize(recurringTransactionList, options);
        File.WriteAllText($@"{fileName}/{recurringTransactionsJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(transactionList, options);
        File.WriteAllText($@"{fileName}/{transactionsJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(transactionGroupList, options);
        File.WriteAllText($@"{fileName}/{transactionGroupsJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(userList, options);
        File.WriteAllText($@"{fileName}/{usersJsonFileName}", jsonString);

        ZipFile.CreateFromDirectory(fileName, fileName + ".zip");
        Directory.Delete(fileName, true);

        return fileName + ".zip";
    }

    public async Task RestoreBackupJsonAsync(string fileName)
    {
        try
        {
            Console.WriteLine("Begin purge");

            if (!File.Exists(fileName)) throw new FileNotFoundException($"File not found: {fileName}");

            ZipFile.ExtractToDirectory(fileName, "restore");

            if (!File.Exists($"restore/{accountsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{accountsJsonFileName}");

            if (!File.Exists($"restore/{categoriesJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{categoriesJsonFileName}");

            if (!File.Exists($"restore/{recurringTransactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{recurringTransactionsJsonFileName}");

            if (!File.Exists($"restore/{transactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{transactionsJsonFileName}");

            if (!File.Exists($"restore/{transactionGroupsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{transactionGroupsJsonFileName}");

            if (!File.Exists($"restore/{usersJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{usersJsonFileName}");

            _dbContext.RemoveRange(await _dbContext.Accounts.ToListAsync());
            _dbContext.RemoveRange(await _dbContext.Categories.ToListAsync());
            _dbContext.RemoveRange(await _dbContext.RecurringTransactions.ToListAsync());
            _dbContext.RemoveRange(await _dbContext.Transactions.ToListAsync());
            _dbContext.RemoveRange(await _dbContext.TransactionGroups.ToListAsync());
            _dbContext.RemoveRange(await _dbContext.ApplicationUsers.ToListAsync());

            Console.WriteLine("Database purged");

            await _dbContext.SaveChangesAsync();

            string jsonString;

            var options = new JsonSerializerOptions { WriteIndented = true };

            Console.WriteLine("Begin restore");

            jsonString = await File.ReadAllTextAsync($"restore/{usersJsonFileName}");
            List<ApplicationUser> users = JsonSerializer.Deserialize<List<ApplicationUser>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{usersJsonFileName}");
            await _dbContext.ApplicationUsers.AddRangeAsync(users);

            Console.WriteLine("Users restored");

            jsonString = await File.ReadAllTextAsync($"restore/{accountsJsonFileName}");
            List<Account> accounts = JsonSerializer.Deserialize<List<Account>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{accountsJsonFileName}");
            await _dbContext.Accounts.AddRangeAsync(accounts);

            Console.WriteLine("Accounts");

            jsonString = await File.ReadAllTextAsync($"restore/{categoriesJsonFileName}");
            List<Category> categories = JsonSerializer.Deserialize<List<Category>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{categoriesJsonFileName}");
            await _dbContext.Categories.AddRangeAsync(categories);

            jsonString = await File.ReadAllTextAsync($"restore/{transactionGroupsJsonFileName}");
            List<TransactionGroup> transactionGroups = JsonSerializer.Deserialize<List<TransactionGroup>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{transactionGroupsJsonFileName}");
            await _dbContext.TransactionGroups.AddRangeAsync(transactionGroups);

            jsonString = await File.ReadAllTextAsync($"restore/{recurringTransactionsJsonFileName}");
            List<RecurringTransaction> recurringTransactions = JsonSerializer.Deserialize<List<RecurringTransaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{recurringTransactionsJsonFileName}");
            await _dbContext.RecurringTransactions.AddRangeAsync(recurringTransactions);

            jsonString = await File.ReadAllTextAsync($"restore/{transactionsJsonFileName}");
            List<Transaction> transactions = JsonSerializer.Deserialize<List<Transaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{transactionGroupsJsonFileName}");
            await _dbContext.Transactions.AddRangeAsync(transactions);

            await _dbContext.SaveChangesAsync();

        } catch(Exception ex)
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
