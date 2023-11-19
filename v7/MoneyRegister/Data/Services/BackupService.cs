using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using System.IO.Compression;
using System.Text.Json;

namespace MoneyRegister.Data.Services;

public class BackupService
{
    private ApplicationDbContext dbContext;
    public static string accountsJsonFileName = $"accounts.json";
    public static string categoriesJsonFileName = $"categories.json";
    public static string filesJsonFileName = $"files.json";
    public static string recurringTransactionsJsonFileName = $"recurring_transactions.json";
    public static string transactionsJsonFileName = $"transactions.json";
    public static string transactionGroupsJsonFileName = $"transaction_groups.json";
    public static string usersJsonFileName = $"users.json";

    public BackupService(ApplicationDbContext dbContext)
    {
        this.dbContext = dbContext;
    }

    public async Task<string> CreateBackupJsonAsync()
    {
        string fileName = $"backup-{DateTime.Now:yyyyMMdd.HHmmdd}";

        List<Account> accountList = await dbContext.Accounts.ToListAsync();
        List<Category> categoryList = await dbContext.Categories.ToListAsync();
//        List<TransactionFile> fileList = await dbContext.Files.ToListAsync();
        List<RecurringTransaction> recurringTransactionList = await dbContext.RecurringTransactions.ToListAsync();
        List<Transaction> transactionList = await dbContext.Transactions.ToListAsync();
        List<TransactionGroup> transactionGroupList = await dbContext.TransactionGroups.ToListAsync();
        List<ApplicationUser> userList = await dbContext.ApplicationUsers.ToListAsync();

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
}
