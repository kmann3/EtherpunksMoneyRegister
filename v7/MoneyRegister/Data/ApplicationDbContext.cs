using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using System.Reflection;
using System.Text.Json;

namespace MoneyRegister.Data;

public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : IdentityDbContext<ApplicationUser>(options)
{
    public DbSet<Account> Accounts { get; set; }
    public DbSet<ApplicationUser> ApplicationUsers { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<TransactionFile> Files { get; set; }
    public DbSet<Lookup_RecurringTransactionFrequency> Lookup_RecurringTransactionFrequencies { get; set; }
    public DbSet<Lookup_TransactionType> Lookup_TransactionTypes { get; set; }
    public DbSet<RecurringTransaction> RecurringTransactions { get; set; }
    public DbSet<TransactionGroup> TransactionGroups { get; set; }
    public DbSet<Transaction> Transactions { get; set; }

    public DbSet<Link_Category_Transaction> Link_Categories_Transactions { get; set; }
    public DbSet<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; set; }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

        //builder.Entity<Link_Category_Transaction>().HasKey(x => new { x.CategoryId, x.TransactionId });
        //builder.Entity<Link_Category_RecurringTransaction>().HasKey(x => new { x.CategoryId, x.RecurringTransactionId });

        builder.Entity<Category>()
            .HasMany(x => x.RecurringTransactions)
            .WithMany(x => x.Categories)
            .UsingEntity<Link_Category_RecurringTransaction>(

            l => l.HasOne<RecurringTransaction>().WithMany(e => e.Link_Category_RecurringTransactions).HasForeignKey(x => x.RecurringTransactionId),

            r => r.HasOne<Category>().WithMany(e => e.Link_Category_RecurringTransactions).HasForeignKey(x => x.CategoryId)
            );

        builder.Entity<Category>()
            .HasMany(x => x.Transactions)
            .WithMany(x => x.Categories)
            .UsingEntity<Link_Category_Transaction>(

            l => l.HasOne<Transaction>().WithMany(e => e.Link_Category_Transactions).HasForeignKey(x => x.TransactionId),

            r => r.HasOne<Category>().WithMany(e => e.Link_Category_Transactions).HasForeignKey(x => x.CategoryId)
            );

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
        Category fastFoodCategory = new() { Name = "fast-food" };
        Category gasCategory = new() { Name = "gas" };
        Category groceriesCategory = new() { Name = "groceries" };
        Category medicationCategory = new() { Name = "medications" };
        Category streamingCategory = new() { Name = "streaming" };

        builder.Entity<Category>().HasData(billsCategory);
        builder.Entity<Category>().HasData(fastFoodCategory);
        builder.Entity<Category>().HasData(gasCategory);
        builder.Entity<Category>().HasData(groceriesCategory);
        builder.Entity<Category>().HasData(medicationCategory);
        builder.Entity<Category>().HasData(streamingCategory);

        Lookup_TransactionType lookup_TransactionType_Debit = new() { Name = "Debit", Ordinal = 0 };
        Lookup_TransactionType lookup_TransactionType_Credit = new() { Name = "Credit", Ordinal = 1 };

        builder.Entity<Lookup_TransactionType>().HasData(lookup_TransactionType_Debit);
        builder.Entity<Lookup_TransactionType>().HasData(lookup_TransactionType_Credit);

        Lookup_RecurringTransactionFrequency lookup_Frequency_Yearly = new() { Name = "Annually", Ordinal = 0 };
        Lookup_RecurringTransactionFrequency lookup_Frequency_Monthly = new() { Name = "Monthly", Ordinal = 1 };
        Lookup_RecurringTransactionFrequency lookup_Frequency_Weekly = new() { Name = "Weekly", Ordinal = 2 };
        Lookup_RecurringTransactionFrequency lookup_Frequency_XDays = new() { Name = "XDays", Ordinal = 3 };
        Lookup_RecurringTransactionFrequency lookup_Frequency_XWeekYDayOfWeek = new() { Name = "XWeekYDayOfWeek", Ordinal = 4 };
        Lookup_RecurringTransactionFrequency lookup_Frequency_Irregular = new() { Name = "Irregular", Ordinal = 5 };
        Lookup_RecurringTransactionFrequency lookup_Frequency_Unknown = new() { Name = "Unknown", Ordinal = 6 };

        builder.Entity<Lookup_RecurringTransactionFrequency>().HasData(lookup_Frequency_Yearly);
        builder.Entity<Lookup_RecurringTransactionFrequency>().HasData(lookup_Frequency_Monthly);
        builder.Entity<Lookup_RecurringTransactionFrequency>().HasData(lookup_Frequency_Weekly);
        builder.Entity<Lookup_RecurringTransactionFrequency>().HasData(lookup_Frequency_XDays);
        builder.Entity<Lookup_RecurringTransactionFrequency>().HasData(lookup_Frequency_XWeekYDayOfWeek);
        builder.Entity<Lookup_RecurringTransactionFrequency>().HasData(lookup_Frequency_Irregular);
        builder.Entity<Lookup_RecurringTransactionFrequency>().HasData(lookup_Frequency_Unknown);

        DateTime nextMonth = DateTime.UtcNow.AddMonths(1);
        DateTime currentMonth = DateTime.UtcNow;

        int month = nextMonth.Month;
        int year = nextMonth.Year;

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
            FrequencyLookupId = lookup_Frequency_Monthly.Id,
            FrequencyValue = 15,
            TransactionTypeLookupId = lookup_TransactionType_Debit.Id,
        };

        builder.Entity<RecurringTransaction>().HasData(recTran_AdobePhotoshop);

        Link_Category_RecurringTransaction recTran1 = new()
        {
            CategoryId = billsCategory.Id,
            RecurringTransactionId = recTran_AdobePhotoshop.Id,
        };

        builder.Entity<Link_Category_RecurringTransaction>().HasData(recTran1);

        RecurringTransaction recTran_Allstate = new()
        {
            Name = "Allstate Apartment Insurance",
            Amount = -16.79M,
            TransactionGroupId = TransactionGroup_AllBills.Id,
            NextDueDate = new DateTime(year, month, 18),
            FrequencyLookupId = lookup_Frequency_Monthly.Id,
            FrequencyValue = 18,
            TransactionTypeLookupId = lookup_TransactionType_Debit.Id,
        };

        Link_Category_RecurringTransaction rectTran2 = new()
        {
            CategoryId = billsCategory.Id,
            RecurringTransactionId = recTran_Allstate.Id,
        };

        builder.Entity<Link_Category_RecurringTransaction>().HasData(rectTran2);

        builder.Entity<RecurringTransaction>().HasData(recTran_Allstate);

        builder.Entity<RecurringTransaction>().HasData(new RecurringTransaction()
        {
            Name = "Test",
            Amount = 150M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(year, month, 18),
            FrequencyLookupId = lookup_Frequency_Monthly.Id,
            FrequencyValue = 18,
            TransactionTypeLookupId = lookup_TransactionType_Credit.Id,
        }); ;

        builder.Entity<RecurringTransaction>().HasData(new RecurringTransaction()
        {
            Name = "Payday",
            Amount = 1343.72M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(currentMonth.AddMonths(-1).Year, currentMonth.AddMonths(-1).Month, 27),
            FrequencyLookupId = lookup_Frequency_XWeekYDayOfWeek.Id,
            FrequencyValue = 4,
            FrequencyDayOfWeekValue = DayOfWeek.Wednesday,
            TransactionTypeLookupId = lookup_TransactionType_Credit.Id,
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
            Balance = 1998M,
            CreatedById = adminUser.Id,
            Name = "payday",
            TransactionPendingUTC = new DateTime(currentMonth.AddMonths(-1).Year, currentMonth.AddMonths(-1).Month, 25),
            TransactionClearedUTC = new DateTime(currentMonth.AddMonths(-1).Year, currentMonth.AddMonths(-1).Month, 25),
            TransactionTypeLookupId = lookup_TransactionType_Credit.Id,
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
            RecurringTransactionId = recTran_AdobePhotoshop.Id,
            TransactionTypeLookupId = lookup_TransactionType_Debit.Id,
        };

        builder.Entity<Transaction>().HasData(trans2);

        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, TransactionId = trans2.Id });

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