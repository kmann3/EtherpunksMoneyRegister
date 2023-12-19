using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using MoneyRegister.Data.Entities.Base;
using MoneyRegister.Data.Services;
using System.Reflection;
using System.Reflection.Emit;
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

        builder.Entity<Transaction>()
            .Property(x => x.TransactionType)
            .HasConversion(
            v => v.ToString(),
            v => (Enums.TransactionType)Enum.Parse(typeof(Enums.TransactionType), v));

        builder.Entity<RecurringTransaction>()
            .Property(x => x.TransactionType)
            .HasConversion(
            v => v.ToString(),
            v => (Enums.TransactionType)Enum.Parse(typeof(Enums.TransactionType), v));

        builder.Entity<RecurringTransaction>()
            .Property(x => x.RecurringFrequencyType)
            .HasConversion(
            v => v.ToString(),
            v => (Enums.RecurringFrequencyType)Enum.Parse(typeof(Enums.RecurringFrequencyType), v));

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
        string fakeDirectory = @"D:\src\fake_data\mmr";
        bool doFakeLoad = false;

        if(Directory.Exists(fakeDirectory) && doFakeLoad)
        {
            if (!File.Exists($"{fakeDirectory}/{BackupService.AccountsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.AccountsJsonFileName}");
            if (!File.Exists($"{fakeDirectory}/{BackupService.CategoriesJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.CategoriesJsonFileName}");
            if (!File.Exists($"{fakeDirectory}/{BackupService.FilesJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.FilesJsonFileName}");
            if (!File.Exists($"{fakeDirectory}/{BackupService.RecurringTransactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.RecurringTransactionsJsonFileName}");
            if (!File.Exists($"{fakeDirectory}/{BackupService.TransactionsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.TransactionsJsonFileName}");
            if (!File.Exists($"{fakeDirectory}/{BackupService.TransactionGroupsJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.TransactionGroupsJsonFileName}");
            if (!File.Exists($"{fakeDirectory}/{BackupService.UsersJsonFileName}")) throw new FileNotFoundException($"Json file not found: {BackupService.UsersJsonFileName}");

            string jsonString = string.Empty;
            var options = new JsonSerializerOptions { WriteIndented = true };

            FillDbType<Category>($"{fakeDirectory}/{BackupService.CategoriesJsonFileName}", builder, options);
            FillDbType<ApplicationUser>($"{fakeDirectory}/{BackupService.UsersJsonFileName}", builder, options);
            FillDbType<Account>($"{fakeDirectory}/{BackupService.AccountsJsonFileName}", builder, options);
            FillDbType<TransactionGroup>($"{fakeDirectory}/{BackupService.TransactionGroupsJsonFileName}", builder, options);
            FillDbType<RecurringTransaction>($"{fakeDirectory}/{BackupService.RecurringTransactionsJsonFileName}", builder, options);
            FillDbType<Transaction>($"{fakeDirectory}/{BackupService.TransactionsJsonFileName}", builder, options);
            FillDbType<Link_Category_Transaction>($"{fakeDirectory}/{BackupService.Link_category_transactionFileName}", builder, options);
            FillDbType<Link_Category_RecurringTransaction>($"{fakeDirectory}/{BackupService.Link_category_recurringTransactionFileName}", builder, options);
            FillDbType<TransactionFile>($"{fakeDirectory}/{BackupService.FilesJsonFileName}", builder, options);

            return;
        }

        // If there is no fake data or data to restore from (probably private stuff), then use some test examples.

        ApplicationUser adminUser = new()
        {
            UserName = "Admin",
            Email = "",
            FirstName = "admin",
            LastName = "admin",
            CreatedOn = DateTime.UtcNow,
            Id = Guid.Empty.ToString(),
        };

        builder.Entity<ApplicationUser>().HasData(adminUser);

        Account account_Cash = new()
        {
            Name = "Neches FCU",
            CreatedById = adminUser.Id,
            CurrentBalance = 68.68M,
            LastBalancedUTC = DateTime.UtcNow,
            StartingBalance = 2111.84M,
            OutstandingItemCount = 2,
            OutstandingBalance = -66.32M,
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

        DateTime nextMonth = DateTime.UtcNow.AddMonths(1);
        DateTime currentMonth = DateTime.UtcNow;

        int month = nextMonth.Month;
        int year = nextMonth.Year;

        TransactionGroup transactionGroup_AllBills = new()
        {
            Name = "All Regular Bills",
        };

        builder.Entity<TransactionGroup>().HasData(transactionGroup_AllBills);

        RecurringTransaction recTran_AdobePhotoshop = new()
        {
            Name = "Adobe Photoshop",
            Amount = -10.81M,
            NextDueDate = new DateTime(year, month, 15),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 15),
            //FrequencyValue = 15,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_AdobePhotoshop, billsCategory.Id);

        RecurringTransaction recTran_Allstate = new()
        {
            Name = "Allstate Apartment Insurance",
            Amount = -16.79M,
            NextDueDate = new DateTime(year, month, 18),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 18),
            //FrequencyValue = 18,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_Allstate, billsCategory.Id);

        RecurringTransaction recTran_AppleiCloud = new()
        {
            Name = "Apple iCloud",
            Amount = -2.99M,
            NextDueDate = new DateTime(year, month, 23),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 23),
            //FrequencyValue = 23,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_AppleiCloud, billsCategory.Id);

        RecurringTransaction recTran_AppleServices = new()
        {
            Name = "Apple Services",
            Amount = -27.92M,
            NextDueDate = new DateTime(year, month, 1),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 1),
            //FrequencyValue = 1,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_AppleServices, billsCategory.Id);

        RecurringTransaction recTran_ATT = new()
        {
            Name = "AT&T",
            Amount = -80.72M,
            NextDueDate = new DateTime(year, month, 28),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 28),
            //FrequencyValue = 28,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_ATT, billsCategory.Id);

        RecurringTransaction recTran_CarLoan = new()
        {
            Name = "Explorer",
            Amount = -719.52M,
            NextDueDate = new DateTime(year, month, 18),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 18),
            //FrequencyValue = 18,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_CarLoan, billsCategory.Id);

        RecurringTransaction recTran_Y = new()
        {
            Name = "Fitness Your Way",
            Amount = -36.81M,
            NextDueDate = new DateTime(year, month, 9),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 9),
            FrequencyValue = 9,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_Y, billsCategory.Id);

        RecurringTransaction recTran_Google = new()
        {
            Name = "Etherpunk",
            Amount = -12.79M,
            NextDueDate = new DateTime(year, month, 1),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 1),
            //FrequencyValue = 1,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_Google, billsCategory.Id);

        RecurringTransaction recTran_Health = new()
        {
            Name = "Health Insurance",
            Amount = -472.12M,
            NextDueDate = new DateTime(year, month, 10),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 10),
            //FrequencyValue = 10,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_Health, billsCategory.Id);

        RecurringTransaction recTran_PersonalLoan = new()
        {
            Name = "Personal Loan",
            Amount = -83.36M,
            NextDueDate = new DateTime(year, month, 5),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 5),
            //FrequencyValue = 5,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_PersonalLoan, billsCategory.Id);

        RecurringTransaction recTran_Verizon = new()
        {
            Name = "Verizon",
            Amount = -104.00M,
            NextDueDate = new DateTime(year, month, 5),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 5),
            //FrequencyValue = 5,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_Verizon, billsCategory.Id);

        RecurringTransaction recTran_Windows = new()
        {
            Name = "WF: Windows",
            Amount = -150.00M,
            NextDueDate = new DateTime(year, month, 5),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 5),
            //FrequencyValue = 5,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
        };

        AddRecTran(builder, recTran_Windows, billsCategory.Id);



        //================

        builder.Entity<RecurringTransaction>().HasData(new RecurringTransaction()
        {
            Name = "Mom-CellPhone",
            Amount = 175M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(year, month, 18),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 18),
            //FrequencyValue = 18,
            TransactionType = Enums.TransactionType.Credit,
        });

        builder.Entity<RecurringTransaction>().HasData(new RecurringTransaction()
        {
            Name = "Payday",
            Amount = 1998M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(currentMonth.Year, currentMonth.Month, 27),
            RecurringFrequencyType = Enums.RecurringFrequencyType.XWeekOnYDayOfWeek,
            FrequencyValue = 4,
            FrequencyDayOfWeekValue = DayOfWeek.Wednesday,
            TransactionType = Enums.TransactionType.Credit,
        });

        RecurringTransaction recTran_IncomeOPM = new()
        {
            Name = "OPM",
            Amount = 378.27M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(currentMonth.AddMonths(1).Year, currentMonth.AddMonths(1).Month, 1),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 1),
            TransactionType = Enums.TransactionType.Credit,
        };
        builder.Entity<RecurringTransaction>().HasData(recTran_IncomeOPM);


        decimal currentBalance = 2111.84M;
        decimal outstandingBalance = 0M;
        decimal transAmount = -0M;
        int outstandingItemsCount = 0;

        transAmount = recTran_PersonalLoan.Amount;
        currentBalance += transAmount;
        Transaction transPersonalLoad = new()
        {
            Name = recTran_PersonalLoan.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_PersonalLoan.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 23),
            TransactionClearedUTC = new DateTime(2023, 11, 23),
            TransactionType = Enums.TransactionType.Debit,
            CreatedById = adminUser.Id,
            AccountId = account_Cash.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23),
        };

        builder.Entity<Transaction>().HasData(transPersonalLoad);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, TransactionId = transPersonalLoad.Id });

        transAmount = recTran_Verizon.Amount;
        currentBalance += transAmount;
        Transaction transVerizon = new()
        {
            Name = recTran_Verizon.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Verizon.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 23),
            TransactionClearedUTC = new DateTime(2023, 11, 23),
            TransactionType = Enums.TransactionType.Debit,
            CreatedById = adminUser.Id,
            AccountId = account_Cash.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23),
        };

        builder.Entity<Transaction>().HasData(transVerizon);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, TransactionId = transVerizon.Id });

        transAmount = -838.07M;
        currentBalance += transAmount;
        Transaction transCapitalOne = new()
        {
            Name = "Capital One",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 11, 24),
            TransactionType = Enums.TransactionType.Debit,
            CreatedById = adminUser.Id,
            AccountId = account_Cash.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 24),
        };

        builder.Entity<Transaction>().HasData(transCapitalOne);

        transAmount = recTran_ATT.Amount;
        currentBalance += transAmount;
        Transaction transAttBill = new()
        {
            Name = recTran_ATT.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_ATT.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 24),
            TransactionClearedUTC = new DateTime(2023, 11, 26),
            TransactionType = Enums.TransactionType.Debit,
            CreatedById = adminUser.Id,
            AccountId = account_Cash.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 24),
        };

        builder.Entity<Transaction>().HasData(transAttBill);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, TransactionId = transAttBill.Id });

        transAmount = recTran_Windows.Amount;
        currentBalance += transAmount;
        Transaction transWindowsBill = new()
        {
            Name = recTran_Windows.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Windows.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 24),
            TransactionClearedUTC = new DateTime(2023, 11, 28),
            TransactionType = Enums.TransactionType.Debit,
            CreatedById = adminUser.Id,
            AccountId = account_Cash.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 24),
        };

        builder.Entity<Transaction>().HasData(transWindowsBill);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, TransactionId = transWindowsBill.Id });

        transAmount = recTran_Health.Amount;
        currentBalance += transAmount;
        Transaction transHealthInsuranceBill = new()
        {
            Name = recTran_Health.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Health.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 27),
            TransactionClearedUTC = new DateTime(2023, 11, 29),
            TransactionType = Enums.TransactionType.Debit,
            CreatedById = adminUser.Id,
            AccountId = account_Cash.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 29),
        };

        builder.Entity<Transaction>().HasData(transHealthInsuranceBill);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, TransactionId = transHealthInsuranceBill.Id });

        transAmount = recTran_IncomeOPM.Amount;
        currentBalance += transAmount;
        Transaction transOPM = new()
        {
            Name = recTran_IncomeOPM.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_IncomeOPM.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 11, 29),
            TransactionType = Enums.TransactionType.Credit,
            CreatedById = adminUser.Id,
            AccountId = account_Cash.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 29),
        };

        builder.Entity<Transaction>().HasData(transOPM);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, TransactionId = transOPM.Id });

        //transAmount = -recTran_AdobePhotoshop.Amount;
        //currentBalance -= transAmount;
        //outstandingBalance -= transAmount;
        //outstandingItemsCount++;
        //Transaction trans2 = new()
        //{
        //    AccountId = account_Cash.Id,
        //    Amount = recTran_AdobePhotoshop.Amount,
        //    Balance = currentBalance,
        //    CreatedById = adminUser.Id,
        //    Name = "Adobe Photoshop",
        //    RecurringTransactionId = recTran_AdobePhotoshop.Id,
        //    TransactionTypeLookupId = lookup_TransactionType_Debit.Id,
        //};

        //builder.Entity<Transaction>().HasData(trans2);

        //builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, TransactionId = trans2.Id });

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

    private void AddRecTran(ModelBuilder builder, RecurringTransaction recTran, Guid billId)
    {
        builder.Entity<RecurringTransaction>().HasData(recTran);

        Link_Category_RecurringTransaction linkCatTran = new()
        {
            CategoryId = billId,
            RecurringTransactionId = recTran.Id,
        };

        builder.Entity<Link_Category_RecurringTransaction>().HasData(linkCatTran);
    }
}