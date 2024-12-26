using EtherpunksMoneyRegister_DAL.Entities;
using EtherpunksMoneyRegister_DAL.Entities.Base;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace DataAccessLayer
{
    public class EMRDbContext : DbContext
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
        
        public static EMRDbContext DbContext { get; set; } = new();

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
            
            //SeedDatabase(builder);

            base.OnModelCreating(builder);
        }

        /// <summary>
        /// Loads a database from a file.
        /// Do not use this method to create a new database.
        /// </summary>
        /// <param name="fileName">The file and location to load</param>
        /// <returns>Returns true if success, returns false if failed.</returns>
        /// <exception cref="FileNotFoundException"></exception>
        /// <exception cref="Exception"></exception>
        public bool LoadDatabaseFromFile(string fileName)
        {
            // This is in case we're supposed to be loading an expected file and do NOT want to create a new file if it's not found.
            if (!File.Exists(fileName))
            {
                throw new FileNotFoundException("Cannot find database");
                return false;
            }

            EMRDbContext.DatabaseLocation = fileName;
            EMRDbContext.DbContext = new EMRDbContext() ?? throw new Exception("Cannot make a new database context.");

            return true;
        }
    }
}
