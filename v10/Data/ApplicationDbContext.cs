using MannsMoneyRegister.Data.Entities;
using MannsMoneyRegister.Data.Entities.Base;
using Microsoft.EntityFrameworkCore;
using System.IO;
using System.Reflection;
using System.Text.Json;

namespace MannsMoneyRegister.Data;
public class ApplicationDbContext : DbContext
{
    public DbSet<Account> Accounts { get; set; }
    public DbSet<AccountTransaction> AccountTransactions { get; set; }
    public DbSet<AccountTransactionFile> AccountTransactionFiles { get; set; }
    public DbSet<Link_Tag_RecurringTransaction> Link_Tag_RecurringTransactions { get; set; }
    public DbSet<Link_Tag_Transaction> Link_Categories_Transactions { get; set; }

    public DbSet<RecurringTransaction> RecurringTransactions { get; set; }
    public DbSet<RecurringTransactionGroup> RecurringTransactionGroups { get; set; }
    public DbSet<Tag> Tags { get; set; }

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
            v => (Enums.TransactionTypeEnum)Enum.Parse(typeof(Enums.TransactionTypeEnum), v));

        builder.Entity<RecurringTransaction>()
            .Property(x => x.TransactionType)
            .HasConversion(
            v => v.ToString(),
            v => (Enums.TransactionTypeEnum)Enum.Parse(typeof(Enums.TransactionTypeEnum), v));

        builder.Entity<RecurringTransaction>()
            .Property(x => x.RecurringFrequencyType)
            .HasConversion(
            v => v.ToString(),
            v => (Enums.RecurringFrequencyTypeEnum)Enum.Parse(typeof(Enums.RecurringFrequencyTypeEnum), v));

        builder.Entity<Tag>()
            .HasMany(x => x.RecurringTransactions)
            .WithMany(x => x.Tags)
            .UsingEntity<Link_Tag_RecurringTransaction>(

            l => l.HasOne<RecurringTransaction>().WithMany(e => e.Link_Tag_RecurringTransactions).HasForeignKey(x => x.RecurringTransactionId),

            r => r.HasOne<Tag>().WithMany(e => e.Link_Tag_RecurringTransactions).HasForeignKey(x => x.TagId)
            );

        builder.Entity<Tag>()
            .HasMany(x => x.AccountTransactions)
            .WithMany(x => x.Tags)
            .UsingEntity<Link_Tag_Transaction>(

            l => l.HasOne<AccountTransaction>().WithMany(e => e.Link_Tag_Transactions).HasForeignKey(x => x.AccountTransactionId),

            r => r.HasOne<Tag>().WithMany(e => e.Link_Tag_Transactions).HasForeignKey(x => x.TagId)
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

        Link_Tag_RecurringTransaction linkCatTran = new()
        {
            TagId = billId.Value,
            RecurringTransactionId = recTran.Id,
        };


        builder.Entity<Link_Tag_RecurringTransaction>().HasData(linkCatTran);
    }
}
