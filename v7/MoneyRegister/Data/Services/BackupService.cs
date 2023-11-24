using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using System.IO.Compression;
using System.Text.Json;

namespace MoneyRegister.Data.Services;

public class BackupService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public static string accountsJsonFileName = $"accounts.json";
    public static string categoriesJsonFileName = $"categories.json";
    public static string filesJsonFileName = $"files.json";
    public static string recurringTransactionsJsonFileName = $"recurring_transactions.json";
    public static string transactionsJsonFileName = $"transactions.json";
    public static string transactionGroupsJsonFileName = $"transaction_groups.json";
    public static string usersJsonFileName = $"users.json";
    public static string link_category_transactionFileName = $"link_category_transaction.json";
    public static string link_category_recurringTransactionFileName = $"link_category_recurringTransaction.json";

    public async Task<string> CreateBackupJsonAsync()
    {
        string fileName = $"backup-{DateTime.Now:yyyyMMdd.HHmmdd}";

        List<Account> accountList = await _context.Accounts.ToListAsync();
        List<Category> categoryList = await _context.Categories.ToListAsync();
//        List<TransactionFile> fileList = await _context.Files.ToListAsync();
        List<RecurringTransaction> recurringTransactionList = await _context.RecurringTransactions.ToListAsync();
        List<Transaction> transactionList = await _context.Transactions.ToListAsync();
        List<TransactionGroup> transactionGroupList = await _context.TransactionGroups.ToListAsync();
        List<ApplicationUser> userList = await _context.ApplicationUsers.ToListAsync();
        List<Link_Category_Transaction> link_category_TransactionList = await _context.Link_Categories_Transactions.ToListAsync();
        List<Link_Category_RecurringTransaction> link_category_RecurringTransactionList = await _context.Link_Category_RecurringTransactions.ToListAsync();

        var options = new JsonSerializerOptions { WriteIndented = true };
        string jsonString = string.Empty;

        Directory.CreateDirectory(fileName);
        try
        {

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

            jsonString = JsonSerializer.Serialize(link_category_TransactionList, options);
            File.WriteAllText($@"{fileName}/{link_category_transactionFileName}", jsonString);

            jsonString = JsonSerializer.Serialize(link_category_RecurringTransactionList, options);
            File.WriteAllText($@"{fileName}/{link_category_recurringTransactionFileName}", jsonString);

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

            if (!File.Exists($"restore/{accountsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{accountsJsonFileName}");

            if (!File.Exists($"restore/{categoriesJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{categoriesJsonFileName}");

            if (!File.Exists($"restore/{recurringTransactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{recurringTransactionsJsonFileName}");

            if (!File.Exists($"restore/{transactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{transactionsJsonFileName}");

            if (!File.Exists($"restore/{transactionGroupsJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{transactionGroupsJsonFileName}");

            if (!File.Exists($"restore/{usersJsonFileName}")) throw new FileNotFoundException($"Json file not found: restore/{usersJsonFileName}");

            if (!File.Exists($"restore/{link_category_transactionFileName}")) throw new FileNotFoundException($"Json file not found: restore/{link_category_transactionFileName}");

            if (!File.Exists($"restore/{link_category_recurringTransactionFileName}")) throw new FileNotFoundException($"Json file not found: restore/{link_category_recurringTransactionFileName}");

            _context.RemoveRange(await _context.Link_Categories_Transactions.ToListAsync());
            _context.RemoveRange(await _context.Link_Category_RecurringTransactions.ToListAsync());
            _context.RemoveRange(await _context.Accounts.ToListAsync());
            _context.RemoveRange(await _context.Categories.ToListAsync());
            _context.RemoveRange(await _context.RecurringTransactions.ToListAsync());
            _context.RemoveRange(await _context.Transactions.ToListAsync());
            _context.RemoveRange(await _context.TransactionGroups.ToListAsync());
            _context.RemoveRange(await _context.ApplicationUsers.ToListAsync());
            

            Console.WriteLine("Database purged");

            await _context.SaveChangesAsync();

            string jsonString;

            var options = new JsonSerializerOptions { WriteIndented = true };

            Console.WriteLine("Begin restore");

            jsonString = await File.ReadAllTextAsync($"restore/{usersJsonFileName}");
            List<ApplicationUser> users = JsonSerializer.Deserialize<List<ApplicationUser>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{usersJsonFileName}");
            await _context.ApplicationUsers.AddRangeAsync(users);

            Console.WriteLine("Users restored");

            jsonString = await File.ReadAllTextAsync($"restore/{accountsJsonFileName}");
            List<Account> accounts = JsonSerializer.Deserialize<List<Account>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{accountsJsonFileName}");
            await _context.Accounts.AddRangeAsync(accounts);

            Console.WriteLine("Accounts");

            jsonString = await File.ReadAllTextAsync($"restore/{categoriesJsonFileName}");
            List<Category> categories = JsonSerializer.Deserialize<List<Category>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{categoriesJsonFileName}");
            await _context.Categories.AddRangeAsync(categories);

            jsonString = await File.ReadAllTextAsync($"restore/{transactionGroupsJsonFileName}");
            List<TransactionGroup> transactionGroups = JsonSerializer.Deserialize<List<TransactionGroup>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{transactionGroupsJsonFileName}");
            await _context.TransactionGroups.AddRangeAsync(transactionGroups);

            jsonString = await File.ReadAllTextAsync($"restore/{recurringTransactionsJsonFileName}");
            List<RecurringTransaction> recurringTransactions = JsonSerializer.Deserialize<List<RecurringTransaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{recurringTransactionsJsonFileName}");
            await _context.RecurringTransactions.AddRangeAsync(recurringTransactions);

            jsonString = await File.ReadAllTextAsync($"restore/{transactionsJsonFileName}");
            List<Transaction> transactions = JsonSerializer.Deserialize<List<Transaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{transactionGroupsJsonFileName}");
            await _context.Transactions.AddRangeAsync(transactions);

            jsonString = await File.ReadAllTextAsync($"restore/{link_category_transactionFileName}");
            List<Link_Category_Transaction> link_category_Transaction = JsonSerializer.Deserialize<List<Link_Category_Transaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{link_category_transactionFileName}");
            await _context.Link_Categories_Transactions.AddRangeAsync(link_category_Transaction);

            jsonString = await File.ReadAllTextAsync($"restore/{link_category_recurringTransactionFileName}");
            List<Link_Category_RecurringTransaction> link_Category_RecurringTransactions = JsonSerializer.Deserialize<List<Link_Category_RecurringTransaction>>(jsonString, options) ?? throw new Exception($"Empty file: restore/{link_category_recurringTransactionFileName}");
            await _context.Link_Category_RecurringTransactions.AddRangeAsync(link_Category_RecurringTransactions);

            await _context.SaveChangesAsync();

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
