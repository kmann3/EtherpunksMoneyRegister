using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MannsMoneyRegister.Data.Entities;
using MannsMoneyRegister.Extensions;
using System.Reflection;

namespace MannsMoneyRegister.Data;

public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : IdentityDbContext<ApplicationUser>(options)
{
    public DbSet<Account> Accounts { get; set; }
    public DbSet<ApplicationUser> ApplicationUsers { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<TransactionFile> Files { get; set; }
    public DbSet<RecurringTransaction> RecurringTransactions { get; set; }
    public DbSet<TransactionGroup> TransactionGroups { get; set; }
    public DbSet<Transaction> Transactions { get; set; }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());


        builder.Entity<Transaction>().HasOne(x => x.CreatedBy).WithMany(x => x.Transactions).OnDelete(DeleteBehavior.NoAction);
        builder.Entity<TransactionFile>().HasOne(x => x.Transaction).WithMany(x => x.Files).OnDelete(DeleteBehavior.NoAction);

        builder.Entity<Transaction>()
            .HasMany(x => x.Categories)
            .WithMany(x => x.Transactions)
            .UsingEntity<Dictionary<string, object>>(
            "Link_Category_Transaction",
            x => x.HasOne<Category>().WithMany().OnDelete(DeleteBehavior.Restrict),
            x => x.HasOne<Transaction>().WithMany().OnDelete(DeleteBehavior.Cascade)
            );

        builder.Entity<RecurringTransaction>()
            .HasMany(x => x.Categories)
            .WithMany(x => x.RecurringTransactions)
            .UsingEntity<Dictionary<string, object>>(
            "Link_Category_RecurringTransactions",
            x => x.HasOne<Category>().WithMany().OnDelete(DeleteBehavior.Restrict),
            x => x.HasOne<RecurringTransaction>().WithMany().OnDelete(DeleteBehavior.Cascade)
            );

        SeedDatabase(builder);

        base.OnModelCreating(builder);
    }

    private void SeedDatabase(ModelBuilder builder)
    {
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

        //====================================================
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
            RecurringTransactionId = recTran_AdobePhotoshop.Id,
            TransactionType = MR_Enum.TransactionType.Debit,
        };

        builder.Entity<Transaction>().HasData(trans2);

        account_Cash.CurrentBalance = currentBalance;
        account_Cash.OutstandingBalance = outstandingBalance;
        account_Cash.OutstandingItemCount = outstandingItemsCount;
        builder.Entity<Account>().HasData(account_Cash);
    }
}
