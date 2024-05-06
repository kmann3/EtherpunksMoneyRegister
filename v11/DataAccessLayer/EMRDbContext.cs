using EtherpunksMoneyRegister_DAL.Entities;
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
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite($"Data Source={DatabaseLocation}");
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

            base.OnModelCreating(builder);
        }
    }
}
