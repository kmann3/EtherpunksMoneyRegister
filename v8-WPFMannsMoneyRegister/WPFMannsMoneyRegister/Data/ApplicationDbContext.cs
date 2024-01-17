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
    public DbSet<Transaction> Transactions { get; set; }

    public static string DatabaseLocation { get; set; } = "MMR.sqlite3";
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlite($"Data Source={DatabaseLocation}");
    }

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
