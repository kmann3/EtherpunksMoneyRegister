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

        if (Directory.Exists(fakeDirectory) && doFakeLoad)
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