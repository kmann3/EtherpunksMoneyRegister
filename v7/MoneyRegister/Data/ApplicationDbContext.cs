using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using MoneyRegister.Data.Services;
using MoneyRegister.Extensions;
using System.Reflection;
using System.Text.Json;

namespace MoneyRegister.Data;

public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : IdentityDbContext<ApplicationUser>(options)
{
    public DbSet<Account> Accounts { get; set; }
    public DbSet<ApplicationUser> ApplicationUsers { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<TransactionFile> Files { get; set; }
    public DbSet<RecurringTransaction> RecurringTransactions { get; set; }
    public DbSet<TransactionGroup> TransactionGroups { get; set; }
    public DbSet<Transaction> Transactions { get; set; }

    public DbSet<Link_Category_Transaction> Link_Categories_Transactions { get; set; }
    public DbSet<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; set; }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

        builder.Entity<Link_Category_Transaction>().HasKey(x => new { x.CategoryId, x.TransactionId });
        builder.Entity<Link_Category_RecurringTransaction>().HasKey(x => new { x.CategoryId, x.RecurringTransactionId });

        //builder.Entity<Transaction>().HasOne(x => x.CreatedBy).WithMany(x => x.Transactions).OnDelete(DeleteBehavior.NoAction);
        //builder.Entity<TransactionFile>().HasOne(x => x.Transaction).WithMany(x => x.Files).OnDelete(DeleteBehavior.NoAction);

        //builder.Entity<Transaction>()
        //    .HasMany(x => x.Categories)
        //    .WithMany(x => x.Transactions)
        //    .UsingEntity<Dictionary<string, object>>(
        //    "Link_Category_Transaction",
        //    x => x.HasOne<Category>().WithMany().OnDelete(DeleteBehavior.Restrict),
        //    x => x.HasOne<Transaction>().WithMany().OnDelete(DeleteBehavior.Cascade)
        //    );

        //builder.Entity<Transaction>()
        //    .HasMany(x => x.Categories)
        //    .WithMany(x => x.Transactions)
        //    .UsingEntity(
        //        "Link_Category_Transaction",
        //        l => l.HasOne(typeof(Category)).WithMany().HasForeignKey("CategoryId").HasPrincipalKey(nameof(Category.Id)),
        //        r => r.HasOne(typeof(Transaction)).WithMany().HasForeignKey("TransactionId").HasPrincipalKey(nameof(Transaction.Id)),
        //        j => j.HasKey("TransactionId", "CategoryId"));

        //builder.Entity<RecurringTransaction>()
        //    .HasMany(x => x.Categories)
        //    .WithMany(x => x.RecurringTransactions)
        //    .UsingEntity<Dictionary<string, object>>(
        //    "Link_Category_RecurringTransactions",
        //    x => x.HasOne<Category>().WithMany().OnDelete(DeleteBehavior.Restrict),
        //    x => x.HasOne<RecurringTransaction>().WithMany().OnDelete(DeleteBehavior.Cascade)
        //    );

        SeedDatabase(builder);

        base.OnModelCreating(builder);
    }

    private void SeedDatabase(ModelBuilder builder)
    {
        //string fakeDirectory = @"D:\src\fake_data\mmr";

        //if(Directory.Exists(fakeDirectory))
        //{

        //    if (!File.Exists($"{fakeDirectory}/{BackupService.accountsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.accountsJsonFileName}");
        //    if (!File.Exists($"{fakeDirectory}/{BackupService.categoriesJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.categoriesJsonFileName}");
        //    //if (!File.Exists($"{fakeDirectory}/{BackupService.filesJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.filesJsonFileName}");
        //    if (!File.Exists($"{fakeDirectory}/{BackupService.recurringTransactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.recurringTransactionsJsonFileName}");
        //    if (!File.Exists($"{fakeDirectory}/{BackupService.transactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.transactionsJsonFileName}");
        //    if (!File.Exists($"{fakeDirectory}/{BackupService.transactionGroupsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.transactionGroupsJsonFileName}");
        //    if (!File.Exists($"{fakeDirectory}/{BackupService.usersJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.usersJsonFileName}");

        //    string jsonString = string.Empty;
        //    var options = new JsonSerializerOptions { WriteIndented = true };

        //    FillDbType<ApplicationUser>($"{fakeDirectory}/{BackupService.usersJsonFileName}", builder, options);
        //    FillDbType<Account>($"{fakeDirectory}/{BackupService.accountsJsonFileName}", builder, options);
        //    FillDbType<Category>($"{fakeDirectory}/{BackupService.categoriesJsonFileName}", builder, options);
        //    FillDbType<RecurringTransaction>($"{fakeDirectory}/{BackupService.recurringTransactionsJsonFileName}", builder, options);
        //    FillDbType<TransactionGroup>($"{fakeDirectory}/{BackupService.transactionGroupsJsonFileName}", builder, options);
        //    FillDbType<Transaction>($"{fakeDirectory}/{BackupService.transactionsJsonFileName}", builder, options);

        //    return;
        //}

        // If there is no fake data or data to restore from (probably private stuff), then use some test examples.

        ApplicationUser adminUser = new()
        {
            UserName = "Admin",
            Email = "",
            FirstName = "admin",
            LastName = "admin",
            CreatedOn = DateTime.UtcNow,
            Id = Guid.Empty.ToString()
        };

        builder.Entity<ApplicationUser>().HasData(adminUser);

        Account account_Cash = new()
        {
            Name = "Cash",
            CreatedById = adminUser.Id,
            CurrentBalance = 68.68M,
            LastBalancedUTC = DateTime.UtcNow,
            StartingBalance = 200M,
            OutstandingItemCount = 2,
            OutstandingBalance = -66.32M
        };

        Category billsCategory = new() { Name = "bills" };
        Category fastfoodCategory = new() { Name = "fast-food" };
        Category gasCategory = new() { Name = "gas" };
        Category groceriesCategory = new() { Name = "groceries" };
        Category medicationCategory = new() { Name = "medications" };
        Category streamingCategory = new() { Name = "streaming" };

        builder.Entity<Category>().HasData(billsCategory);
        builder.Entity<Category>().HasData(fastfoodCategory);
        builder.Entity<Category>().HasData(gasCategory);
        builder.Entity<Category>().HasData(groceriesCategory);
        builder.Entity<Category>().HasData(medicationCategory);
        builder.Entity<Category>().HasData(streamingCategory);

        int month = DateTime.UtcNow.Month + 1;
        int year = DateTime.UtcNow.Year;


        TransactionGroup TransactionGroup_AllBills = new()
        {
            Name = "All Regular Bills"
        };

        builder.Entity<TransactionGroup>().HasData(TransactionGroup_AllBills);

        RecurringTransaction recTran_AdobePhotoshop = new()
        {
            Name = "Adobe Photoshop",
            Amount = -10.81M,
            TransactionGroupId = TransactionGroup_AllBills.Id,
            NextDueDate = new DateTime(year, month, 15),
            Frequency = MR_Enum.Regularity.Monthly,
            TransactionType = MR_Enum.TransactionType.Debit,
        };

        builder.Entity<RecurringTransaction>().HasData(recTran_AdobePhotoshop);

        RecurringTransaction recTran_Allstate = new()
        {
            Name = "Allstate Apartment Insurance",
            Amount = -16.79M,
            TransactionGroupId = TransactionGroup_AllBills.Id,
            NextDueDate = new DateTime(year, month, 18),
            Frequency = MR_Enum.Regularity.Monthly,
            TransactionType = MR_Enum.TransactionType.Debit
        };

        builder.Entity<RecurringTransaction>().HasData(recTran_Allstate);

        builder.Entity<RecurringTransaction>().HasData(new RecurringTransaction()
        {
            Name = "Test",
            Amount = 150M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(year, month, 18),
            Frequency = MR_Enum.Regularity.Monthly,
            TransactionType = MR_Enum.TransactionType.Credit
        });

        builder.Entity<RecurringTransaction>().HasData(new RecurringTransaction()
        {
            Name = "Payday",
            Amount = 1343.72M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(year, month, 22),
            Frequency = MR_Enum.Regularity.Monthly,
            TransactionType = MR_Enum.TransactionType.Credit
        });


        decimal currentBalance = 0M;
        decimal outstandingBalance = 0M;
        decimal transAmount = -0M;
        int outstandingItemsCount = 0;

        transAmount = 1998M;
        currentBalance += transAmount;
        Transaction transIncomeSSDI = new()
        {
            AccountId = account_Cash.Id,
            Amount = transAmount,
            Balance = 1343.72M,
            CreatedById = adminUser.Id,
            Name = "payday",
            TransactionPendingUTC = new DateTime(year, month - 1, 25),
            TransactionClearedUTC = new DateTime(year, month - 1, 25),
            TransactionType = MR_Enum.TransactionType.Credit,
        };

        builder.Entity<Transaction>().HasData(transIncomeSSDI);

        transAmount = -recTran_AdobePhotoshop.Amount;
        currentBalance -= transAmount;
        outstandingBalance -= transAmount;
        outstandingItemsCount++;
        Transaction trans2 = new()
        {
            AccountId = account_Cash.Id,
            Amount = recTran_AdobePhotoshop.Amount,
            Balance = currentBalance,
            CreatedById = adminUser.Id,
            Name = "Adobe Photoshop",
            //Categories = new List<Category>(),
            RecurringTransactionId = recTran_AdobePhotoshop.Id,
            TransactionType = MR_Enum.TransactionType.Debit,
        };

        builder.Entity<Transaction>().HasData(trans2);

        Link_Category_Transaction trans2CatLink = new()
        {
            CategoryId = billsCategory.Id,
            TransactionId = trans2.Id
        };

        builder.Entity<Link_Category_Transaction>().HasData(trans2CatLink);

        account_Cash.CurrentBalance = currentBalance;
        account_Cash.OutstandingBalance = outstandingBalance;
        account_Cash.OutstandingItemCount = outstandingItemsCount;
        builder.Entity<Account>().HasData(account_Cash);
    }

    private static void FillDbType<TEntity>(string fileLocation, ModelBuilder builder, JsonSerializerOptions options) where TEntity : class
    {
        string jsonString = File.ReadAllText(fileLocation);
        List<TEntity> accountList = JsonSerializer.Deserialize<List<TEntity>>(jsonString!, options) ?? throw new Exception($"Empty file: {fileLocation}");
        foreach (TEntity account in accountList)
        {
            builder.Entity<TEntity>().HasData(account);
        }

    }
}
