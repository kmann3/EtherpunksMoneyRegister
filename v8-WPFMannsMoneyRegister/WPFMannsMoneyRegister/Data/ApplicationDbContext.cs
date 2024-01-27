using Microsoft.EntityFrameworkCore;
using System.IO;
using System.Reflection;
using System.Reflection.Emit;
using System.Text.Json;
using WPFMannsMoneyRegister.Data.Entities;
using WPFMannsMoneyRegister.Data.Entities.Base;

namespace WPFMannsMoneyRegister.Data;

class ApplicationDbContext : DbContext
{
    public DbSet<Account> Accounts { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<TransactionFile> Files { get; set; }
    public DbSet<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; set; }
    public DbSet<Link_Category_Transaction> Link_Categories_Transactions { get; set; }

    public DbSet<RecurringTransaction> RecurringTransactions { get; set; }
    public DbSet<Settings> Settings { get; set; }
    public DbSet<TransactionGroup> TransactionGroups { get; set; }
    public DbSet<AccountTransaction> AccountTransactions { get; set; }

    public static string DatabaseLocation { get; set; } = "MMR.sqlite3";
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlite($"Data Source={DatabaseLocation}");
    }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

        builder.Entity<AccountTransaction>()
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
            .HasMany(x => x.AccountTransactions)
            .WithMany(x => x.Categories)
            .UsingEntity<Link_Category_Transaction>(

            l => l.HasOne<AccountTransaction>().WithMany(e => e.Link_Category_Transactions).HasForeignKey(x => x.AccountTransactionId),

            r => r.HasOne<Category>().WithMany(e => e.Link_Category_Transactions).HasForeignKey(x => x.CategoryId)
            );
        SeedDatabase(builder);
        base.OnModelCreating(builder);
    }

    private void SeedDatabase(ModelBuilder builder)
    {
        Account account_Neches = new()
        {
            Name = "Neches FCU",
            CurrentBalance = 68.68M,
            LastBalancedUTC = DateTime.UtcNow,
            StartingBalance = 2111.84M,
            OutstandingItemCount = 2,
            OutstandingBalance = -66.32M,
        };

        Account account_CapitalOne = new()
        {
            Name = "Capital One",
            CurrentBalance = -973.31M,
            LastBalancedUTC = DateTime.UtcNow,
            StartingBalance = -862.4M,
            OutstandingItemCount = 3,
            OutstandingBalance = -110.91M,
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

        DateTime nextMonthDt = DateTime.UtcNow.AddMonths(1);
        DateTime currentMonth = DateTime.UtcNow;

        int nextMonth = nextMonthDt.Month;
        int nextYear = nextMonthDt.Year;

        TransactionGroup transactionGroup_AllBills = new()
        {
            Name = "All Regular Bills",
        };

        builder.Entity<TransactionGroup>().HasData(transactionGroup_AllBills);

        RecurringTransaction recTran_AdobePhotoshop = new()
        {
            Name = "Adobe Photoshop",
            Amount = -10.81M,
            NextDueDate = new DateTime(nextYear, nextMonth, 15),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 15),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "CA 408 536 6000 ADOBE INC.",
        };

        AddRecTran(builder, recTran_AdobePhotoshop, billsCategory.Id);

        RecurringTransaction recTran_Allstate = new()
        {
            Name = "Allstate Apartment Insurance",
            Amount = -16.79M,
            NextDueDate = new DateTime(nextYear, nextMonth, 18),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 18),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "ALLSTATE INS CO (INS PREM)",
        };

        AddRecTran(builder, recTran_Allstate, billsCategory.Id);

        RecurringTransaction recTran_AppleiCloud = new()
        {
            Name = "Apple iCloud",
            Amount = -2.99M,
            NextDueDate = new DateTime(nextYear, nextMonth, 23),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 23),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_AppleiCloud, billsCategory.Id);

        RecurringTransaction recTran_AppleServices = new()
        {
            Name = "Apple Services",
            Amount = -27.92M,
            NextDueDate = new DateTime(nextYear, nextMonth, 1),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 1),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_AppleServices, billsCategory.Id);

        RecurringTransaction recTran_ATT = new()
        {
            Name = "AT&T",
            Amount = -80.72M,
            NextDueDate = new DateTime(nextYear, nextMonth, 28),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 28),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "TX 800 331 0500 ATT*BILL",
        };

        AddRecTran(builder, recTran_ATT, billsCategory.Id);

        RecurringTransaction recTran_CarLoan = new()
        {
            Name = "Explorer",
            Amount = -719.52M,
            NextDueDate = new DateTime(nextYear, nextMonth, 18),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 18),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "Transfer",
        };

        AddRecTran(builder, recTran_CarLoan, billsCategory.Id);

        RecurringTransaction recTran_Y = new()
        {
            Name = "Fitness Your Way",
            Amount = -36.81M,
            NextDueDate = new DateTime(nextYear, nextMonth, 9),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 9),
            FrequencyValue = 9,
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "TN 888 242 2060 FITNESS YOUR",
        };

        AddRecTran(builder, recTran_Y, billsCategory.Id);

        RecurringTransaction recTran_Google = new()
        {
            Name = "Etherpunk",
            Amount = -12.79M,
            NextDueDate = new DateTime(nextYear, nextMonth, 1),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 1),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "CA CC GOOGLE.COM GOOGLE*GSUITE",
        };

        AddRecTran(builder, recTran_Google, billsCategory.Id);

        RecurringTransaction recTran_Health = new()
        {
            Name = "Health Insurance",
            Amount = -472.12M,
            NextDueDate = new DateTime(nextYear, nextMonth, 10),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 10),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "WEBUSDA NFC DPRS (ONLINE PMT)",
        };

        AddRecTran(builder, recTran_Health, billsCategory.Id);

        RecurringTransaction recTran_PersonalLoan = new()
        {
            Name = "Personal Loan",
            Amount = -83.36M,
            NextDueDate = new DateTime(nextYear, nextMonth, 5),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 5),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "Transfer",
        };

        AddRecTran(builder, recTran_PersonalLoan, billsCategory.Id);

        RecurringTransaction recTran_Verizon = new()
        {
            Name = "Verizon",
            Amount = -104.00M,
            NextDueDate = new DateTime(nextYear, nextMonth, 5),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 5),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "WEBVENMO (PAYMENT)",
            Notes = "Venmo money to Tim",
        };

        AddRecTran(builder, recTran_Verizon, billsCategory.Id);

        RecurringTransaction recTran_Windows = new()
        {
            Name = "WF: Windows",
            Amount = -150.00M,
            NextDueDate = new DateTime(nextYear, nextMonth, 5),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 5),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "WEBWELLS FARGO CARD (CCPYMT)",
        };

        AddRecTran(builder, recTran_Windows, billsCategory.Id);

        RecurringTransaction recTran_AirConditioner = new()
        {
            Name = "WF: A/C",
            Amount = -67.5M,
            NextDueDate = new DateTime(2024, 1, 9),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2024, 1, 9),
            TransactionGroupId = transactionGroup_AllBills.Id,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_AirConditioner, billsCategory.Id);

        RecurringTransaction recTran_SmarterASP = new()
        {
            Name = "Smarter ASP.Net: Etherpunk Web Hosting",
            Amount = -83.4M,
            NextDueDate = new DateTime(2024, 1, 24),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Yearly,
            FrequencyDateValue = new DateTime(2024, 1, 24),
            TransactionGroupId = null,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_SmarterASP, null);

        RecurringTransaction recTran_Namecheap = new()
        {
            Name = "Namecheap: Etherpunk DNS",
            Amount = -15.88M,
            NextDueDate = new DateTime(2024, 10, 29),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Yearly,
            FrequencyDateValue = new DateTime(2024, 10, 29),
            TransactionGroupId = null,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_Namecheap, null);

        RecurringTransaction recTran_Amazon = new()
        {
            Name = "Amazon",
            Amount = -150.47M,
            NextDueDate = new DateTime(2024, 12, 19),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Yearly,
            FrequencyDateValue = new DateTime(2024, 12, 19),
            TransactionGroupId = null,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_Amazon, null);

        RecurringTransaction recTran_DexterGrooming = new()
        {
            Name = "Monique: Dexter Grooming",
            Amount = -70M,
            NextDueDate = null,
            RecurringFrequencyType = Enums.RecurringFrequencyType.Unknown,
            FrequencyDateValue = null,
            TransactionGroupId = null,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_DexterGrooming, null);

        RecurringTransaction recTran_Office365 = new()
        {
            Name = "Office 365",
            Amount = -108.24M,
            NextDueDate = new DateTime(2024, 4, 16),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Yearly,
            FrequencyDateValue = new DateTime(2024, 4, 16),
            TransactionGroupId = null,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_Office365, null);

        RecurringTransaction recTran_BillClark = new()
        {
            Name = "Bill Clark",
            Amount = -98.51M,
            NextDueDate = null,
            RecurringFrequencyType = Enums.RecurringFrequencyType.Irregular,
            FrequencyDateValue = null,
            TransactionGroupId = null,
            TransactionType = Enums.TransactionType.Debit,
            BankTransactionText = "",
        };

        AddRecTran(builder, recTran_BillClark, null);

        //================
        // Credits
        //================

        builder.Entity<RecurringTransaction>().HasData(new RecurringTransaction()
        {
            Name = "Mom-CellPhone",
            Amount = 175M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(nextYear, nextMonth, 18),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 18),
            //FrequencyValue = 18,
            TransactionType = Enums.TransactionType.Credit,
        });

        RecurringTransaction recTran_SSDI = new()
        {
            Name = "SSDI",
            Amount = 1998M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(currentMonth.Year, currentMonth.Month, 27),
            RecurringFrequencyType = Enums.RecurringFrequencyType.XWeekOnYDayOfWeek,
            FrequencyValue = 4,
            FrequencyDayOfWeekValue = DayOfWeek.Wednesday,
            TransactionType = Enums.TransactionType.Credit,
            BankTransactionText = "SSA TREAS 310 (XXSOC SEC)",
        };

        builder.Entity<RecurringTransaction>().HasData(recTran_SSDI);

        RecurringTransaction recTran_IncomeOPM = new()
        {
            Name = "OPM",
            Amount = 378.27M,
            TransactionGroupId = null,
            NextDueDate = new DateTime(currentMonth.AddMonths(1).Year, currentMonth.AddMonths(1).Month, 1),
            RecurringFrequencyType = Enums.RecurringFrequencyType.Monthly,
            FrequencyDateValue = new DateTime(2023, 1, 1),
            TransactionType = Enums.TransactionType.Credit,
            BankTransactionText = "OPM1 TREAS 310 (XXCIV SERV)",
        };
        builder.Entity<RecurringTransaction>().HasData(recTran_IncomeOPM);

        //=========
        // Transactions
        //=========

        decimal currentBalance = 2111.84M;
        decimal outstandingBalance = 0M;
        decimal transAmount = -0M;
        int outstandingItemsCount = 0;
        int createdOnCheat = 0;

        transAmount = recTran_PersonalLoan.Amount;
        currentBalance += transAmount;
        AccountTransaction transPersonalLoan = new()
        {
            Name = recTran_PersonalLoan.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_PersonalLoan.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 23),
            TransactionClearedUTC = new DateTime(2023, 11, 23),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transPersonalLoan);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transPersonalLoan.Id });

        transAmount = recTran_Verizon.Amount;
        currentBalance += transAmount;
        AccountTransaction transVerizon = new()
        {
            Name = recTran_Verizon.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Verizon.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 23),
            TransactionClearedUTC = new DateTime(2023, 11, 23),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transVerizon);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transVerizon.Id });

        transAmount = -838.07M;
        currentBalance += transAmount;
        AccountTransaction transCapitalOne = new()
        {
            Name = "Capital One",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 11, 24),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transCapitalOne);

        transAmount = recTran_ATT.Amount;
        currentBalance += transAmount;
        AccountTransaction transAttBill = new()
        {
            Name = recTran_ATT.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_ATT.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 24),
            TransactionClearedUTC = new DateTime(2023, 11, 26),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transAttBill);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transAttBill.Id });

        transAmount = recTran_Windows.Amount;
        currentBalance += transAmount;
        AccountTransaction transWindowsBill = new()
        {
            Name = recTran_Windows.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Windows.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 24),
            TransactionClearedUTC = new DateTime(2023, 11, 28),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transWindowsBill);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transWindowsBill.Id });

        transAmount = recTran_Health.Amount;
        currentBalance += transAmount;
        AccountTransaction transHealthInsuranceBill = new()
        {
            Name = recTran_Health.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Health.Id,
            TransactionPendingUTC = new DateTime(2023, 11, 27),
            TransactionClearedUTC = new DateTime(2023, 11, 29),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transHealthInsuranceBill);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transHealthInsuranceBill.Id });

        transAmount = recTran_IncomeOPM.Amount;
        currentBalance += transAmount;
        AccountTransaction transOPM = new()
        {
            Name = recTran_IncomeOPM.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_IncomeOPM.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 11, 29),
            TransactionType = Enums.TransactionType.Credit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transOPM);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transOPM.Id });

        transAmount = -100;
        currentBalance += transAmount;
        AccountTransaction transAlice = new()
        {
            Name = "Alice",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = new DateTime(2023, 11, 28),
            TransactionClearedUTC = new DateTime(2023, 11, 29),
            Notes = "Help Alice Rent / Venmo",
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transAlice);

        transAmount = recTran_Google.Amount;
        currentBalance += transAmount;
        AccountTransaction transGoogle = new()
        {
            Name = recTran_Google.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Google.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 12, 1),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transGoogle);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transGoogle.Id });

        transAmount = 0.06M;
        currentBalance += transAmount;
        AccountTransaction transDividends = new()
        {
            Name = "Dividends",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 12, 1),
            TransactionType = Enums.TransactionType.Credit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transDividends);

        transAmount = -500M;
        currentBalance += transAmount;
        AccountTransaction transCapitalOneBill = new()
        {
            Name = "Capital One",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = new DateTime(2023, 12, 3),
            TransactionClearedUTC = new DateTime(2023, 12, 5),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transCapitalOneBill);

        transAmount = -35M;
        currentBalance += transAmount;
        AccountTransaction transAppleCardMisc = new()
        {
            Name = "Capital One",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = new DateTime(2023, 12, 3),
            TransactionClearedUTC = new DateTime(2023, 12, 5),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transAppleCardMisc);

        transAmount = recTran_Y.Amount;
        currentBalance += transAmount;
        AccountTransaction transFitnessMyWay = new()
        {
            Name = recTran_Y.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Y.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 12, 9),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transFitnessMyWay);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transFitnessMyWay.Id });

        transAmount = recTran_AdobePhotoshop.Amount;
        currentBalance += transAmount;
        AccountTransaction transAdobe = new()
        {
            Name = recTran_AdobePhotoshop.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_AdobePhotoshop.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 12, 14),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transAdobe);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transAdobe.Id });

        transAmount = 250M;
        currentBalance += transAmount;
        AccountTransaction transMomXmasBirthday = new()
        {
            Name = "Mom / Xmas+Birthday",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 12, 16),
            TransactionType = Enums.TransactionType.Credit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transMomXmasBirthday);

        transAmount = -70M;
        currentBalance += transAmount;
        AccountTransaction transMonique = new()
        {
            Name = "Monique / Dexter Grooming",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = new DateTime(2023, 12, 16),
            TransactionClearedUTC = new DateTime(2023, 12, 18),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transMonique);

        transAmount = 175M;
        currentBalance += transAmount;
        AccountTransaction transMomVerizon = new()
        {
            Name = "Mom / Cell Phone",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 12, 18),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transMomVerizon);

        transAmount = recTran_Allstate.Amount;
        currentBalance += transAmount;
        AccountTransaction transAllState = new()
        {
            Name = recTran_Allstate.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_Allstate.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 12, 19),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 12, 19, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transAllState);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transAllState.Id });

        transAmount = recTran_AppleiCloud.Amount;
        currentBalance += transAmount;
        outstandingItemsCount++;
        outstandingBalance += transAmount;
        AccountTransaction transiCloud = new()
        {
            Name = recTran_AppleiCloud.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_AppleiCloud.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = null,
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transiCloud);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transiCloud.Id });

        transAmount = recTran_AppleServices.Amount;
        currentBalance += transAmount;
        outstandingItemsCount++;
        outstandingBalance += transAmount;
        AccountTransaction transAppleServices = new()
        {
            Name = recTran_AppleServices.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_AppleServices.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = null,
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 11, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transAppleServices);
        builder.Entity<Link_Category_Transaction>().HasData(new Link_Category_Transaction() { CategoryId = billsCategory.Id, AccountTransactionId = transAppleServices.Id });

        transAmount = recTran_SSDI.Amount;
        currentBalance += transAmount;
        AccountTransaction transSSDIDec = new()
        {
            Name = recTran_SSDI.Name,
            Amount = transAmount,
            RecurringTransactionId = recTran_SSDI.Id,
            TransactionPendingUTC = null,
            TransactionClearedUTC = new DateTime(2023, 12, 22),
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_Neches.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 12, 22, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transSSDIDec);

        account_Neches.CurrentBalance = currentBalance;
        account_Neches.OutstandingBalance = outstandingBalance;
        account_Neches.OutstandingItemCount = outstandingItemsCount;
        builder.Entity<Account>().HasData(account_Neches);

        currentBalance = -862.4M;
        createdOnCheat = 0;

        transAmount = -30.29M;
        currentBalance += transAmount;
        AccountTransaction transValve = new AccountTransaction()
        {
            Name = "Valve",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = new DateTime(2023, 12, 23),
            TransactionClearedUTC = null,
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_CapitalOne.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 12, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transValve);

        transAmount = -9.73M;
        currentBalance += transAmount;
        AccountTransaction transWhataburger = new ()
        {
            Name = "Whataburger",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = new DateTime(2023, 12, 23),
            TransactionClearedUTC = null,
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_CapitalOne.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 12, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transWhataburger);

        transAmount = -70.89M;
        currentBalance += transAmount;
        AccountTransaction transSmarterAsp = new ()
        {
            Name = "SMARTERASP.NET",
            Amount = transAmount,
            RecurringTransactionId = null,
            TransactionPendingUTC = new DateTime(2023, 12, 23),
            TransactionClearedUTC = null,
            TransactionType = Enums.TransactionType.Debit,
            AccountId = account_CapitalOne.Id,
            Balance = currentBalance,
            CreatedOnUTC = new DateTime(2023, 12, 23, 0, 0, createdOnCheat++),
        };

        builder.Entity<AccountTransaction>().HasData(transSmarterAsp);

        builder.Entity<Account>().HasData(account_CapitalOne);

        Settings predefinedSettings = new Settings()
        {
            Id = 1,
            DefaultAccountId = account_Neches.Id,
            SearchDayCount = 45,
        };

        builder.Entity<Settings>().HasData(predefinedSettings);
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

    private void AddRecTran(ModelBuilder builder, RecurringTransaction recTran, Guid? billId)
    {
        builder.Entity<RecurringTransaction>().HasData(recTran);

        if (billId == null) return;

        Link_Category_RecurringTransaction linkCatTran = new()
        {
            CategoryId = billId.Value,
            RecurringTransactionId = recTran.Id,
        };


        builder.Entity<Link_Category_RecurringTransaction>().HasData(linkCatTran);
    }
}
