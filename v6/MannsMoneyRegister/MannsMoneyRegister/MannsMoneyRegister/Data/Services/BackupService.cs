using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore;
using System.IO.Compression;
using System.Text.Json;

namespace MannsMoneyRegister.Data.Services;

public class BackupService
{
    private ApplicationDbContext _context;
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
        this._context = dbContext;
    }

    public async Task<string> CreateBackupJsonAsync()
    {
        string fileName = $"backup-{DateTime.Now:yyyyMMdd.HHmmdd}";

        List<Account> accountList = await _context.Accounts.ToListAsync();
//            List<BillGroup> billGroupList = await dbContext.BillGroups.ToListAsync();
//            List<Bill> billList = await dbContext.Bills.ToListAsync();
//            List<Category> categoryList = await dbContext.Categories.ToListAsync();
//            List<TransactionFile> fileList = await dbContext.Files.ToListAsync();
//            List<Transaction> transactionList = await dbContext.Transactions.ToListAsync();
//            List<ApplicationUser> userList = await dbContext.ApplicationUsers.ToListAsync();

        var options = new JsonSerializerOptions { WriteIndented = true };
        string jsonString = string.Empty;

        Directory.CreateDirectory(fileName);

        jsonString = JsonSerializer.Serialize(accountList, options);
        File.WriteAllText($@"{fileName}/{accountsJsonFileName}", jsonString);

//            jsonString = JsonSerializer.Serialize(billGroupList, options);
//            File.WriteAllText($@"{fileName}/{billGroupsJsonFileName}", jsonString);

//            jsonString = JsonSerializer.Serialize(billList, options);
//            File.WriteAllText($@"{fileName}/{billsJsonFileName}", jsonString);

//            jsonString = JsonSerializer.Serialize(categoryList, options);
//            File.WriteAllText($@"{fileName}/{categoriesJsonFileName}", jsonString);

//            jsonString = JsonSerializer.Serialize(fileList, options);
//            File.WriteAllText($@"{fileName}/{filesJsonFileName}", jsonString);
//            // TODO: SAVE ACTUAL FILE DATA HERE
//#if !DEBUG
//throw new NotImplementedException("IMPLEMENT FILE SAVE DATA");
//#endif

//            jsonString = JsonSerializer.Serialize(transactionList, options);
//            File.WriteAllText($@"{fileName}/{transactionsJsonFileName}", jsonString);

//            jsonString = JsonSerializer.Serialize(userList, options);
//            File.WriteAllText($@"{fileName}/{usersJsonFileName}", jsonString);

        ZipFile.CreateFromDirectory(fileName, fileName + ".zip");
        Directory.Delete(fileName, true);

//            // Should we just copy the entire database?
//            //File.Copy("mmr.sqlite", "mmr_backup.sqlite", true);

        return fileName + ".zip";
    }
}
