namespace MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore;
using System.IO.Compression;
using System.Reflection;
using System.Text.Json;
using System.Xml;

public class BackupService
{
    private ApplicationDbContext dbContext;
    private string restoreDirectory = "restore";
    private string accountsJsonFileName = $"accounts.json";
    private string billGroupsJsonFileName = $"billGroups.json";
    private string billsJsonFileName = $"bills.json";
    private string categoriesJsonFileName = $"categories.json";
    private string filesJsonFileName = $"files.json";
    private string transactionsJsonFileName = $"transactions.json";
    private string usersJsonFileName = $"users.json";

    public BackupService(ApplicationDbContext dbContext)
    {
        this.dbContext = dbContext;
    }

    public async Task<string> CreateBackupJsonAsync()
    {
        string fileName = $"backup-{DateTime.Now.ToString("yyyyMMdd.HHmmdd")}";

        List<Account> accountList = await dbContext.Accounts.ToListAsync();
        List<BillGroup> billGroupList = await dbContext.BillGroups.ToListAsync();
        List<Bill> billList = await dbContext.Bills.ToListAsync();
        List<Category> categoryList = await dbContext.Categories.ToListAsync();
        List<TransactionFile> fileList = await dbContext.Files.ToListAsync();
        List<Transaction> transactionList = await dbContext.Transactions.ToListAsync();
        List<ApplicationUser> userList = await dbContext.ApplicationUsers.ToListAsync();

        var options = new JsonSerializerOptions { WriteIndented = true };
        string jsonString = string.Empty;

        Directory.CreateDirectory(fileName);

        jsonString = JsonSerializer.Serialize(accountList, options);
        File.WriteAllText($@"{fileName}/{accountsJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(billGroupList, options);
        File.WriteAllText($@"{fileName}/{billGroupsJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(billList, options);
        File.WriteAllText($@"{fileName}/{billsJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(categoryList, options);
        File.WriteAllText($@"{fileName}/{categoriesJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(fileList, options);
        File.WriteAllText($@"{fileName}/{filesJsonFileName}", jsonString);
        // TODO: SAVE ACTUAL FILE DATA HERE
#if !DEBUG
throw new NotImplementedException("IMPLEMENT FILE SAVE DATA");
#endif

        jsonString = JsonSerializer.Serialize(transactionList, options);
        File.WriteAllText($@"{fileName}/{transactionsJsonFileName}", jsonString);

        jsonString = JsonSerializer.Serialize(userList, options);
        File.WriteAllText($@"{fileName}/{usersJsonFileName}", jsonString);

        ZipFile.CreateFromDirectory(fileName, fileName + ".zip");
        Directory.Delete(fileName, true);

        // Should we just copy the entire database?
        //File.Copy("mmr.sqlite", "mmr_backup.sqlite", true);

        return fileName + ".zip";
    }

    public async Task RestoreBackupJsonAsync(string fileName)
    {
        if (!File.Exists(fileName)) throw new FileNotFoundException($"File not found: {fileName}");

        ZipFile.ExtractToDirectory(fileName, "restore");

        // Let's make sure all appropriate files exist
        if (!File.Exists($"{restoreDirectory}/{accountsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {restoreDirectory}/{accountsJsonFileName}");

        if (!File.Exists($"{restoreDirectory}/{billGroupsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {restoreDirectory}/{billGroupsJsonFileName}");

        if (!File.Exists($"{restoreDirectory}/{billsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {restoreDirectory}/{billsJsonFileName}");

        if (!File.Exists($"{restoreDirectory}/{categoriesJsonFileName}")) throw new FileNotFoundException($"Json file not found: {restoreDirectory}/{categoriesJsonFileName}");

        if (!File.Exists($"{restoreDirectory}/{filesJsonFileName}")) throw new FileNotFoundException($"Json file not found: {restoreDirectory}/{filesJsonFileName}");

        if (!File.Exists($"{restoreDirectory}/{transactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {restoreDirectory}/{transactionsJsonFileName}");

        if (!File.Exists($"{restoreDirectory}/{usersJsonFileName}")) throw new FileNotFoundException($"Json file not found: {restoreDirectory}/{usersJsonFileName}");

        // Clear the database
        dbContext.RemoveRange(await dbContext.Accounts.ToListAsync());
        dbContext.RemoveRange(await dbContext.BillGroups.ToListAsync());
        dbContext.RemoveRange(await dbContext.Bills.ToListAsync());
        dbContext.RemoveRange(await dbContext.Categories.ToListAsync());
        dbContext.RemoveRange(await dbContext.Files.ToListAsync());
        dbContext.RemoveRange(await dbContext.Transactions.ToListAsync());
        dbContext.RemoveRange(await dbContext.ApplicationUsers.ToListAsync());

        await dbContext.SaveChangesAsync();

        // Reload the database

        string jsonString = String.Empty;
        var options = new JsonSerializerOptions { WriteIndented = true };

        jsonString = await File.ReadAllTextAsync($"{restoreDirectory}/{accountsJsonFileName}");
        List<Account> accountList = JsonSerializer.Deserialize<List<Account>>(jsonString, options);
        foreach(var account in accountList)
        {
            dbContext.Accounts.Add(account);
        }

        await dbContext.SaveChangesAsync();

        jsonString = await File.ReadAllTextAsync($"{restoreDirectory}/{billGroupsJsonFileName}");
        List<BillGroup> billGroups = JsonSerializer.Deserialize<List<BillGroup>>(jsonString, options);
        foreach (var group in billGroups)
        {
            dbContext.BillGroups.Add(group);
        }

        Directory.Delete("restore", true);

        return;
    }    
}
