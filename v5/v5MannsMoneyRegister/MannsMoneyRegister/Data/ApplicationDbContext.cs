using MannsMoneyRegister.Data.Entities;
using MannsMoneyRegister.Pages;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System.Reflection;
using System.Reflection.Emit;

namespace MannsMoneyRegister.Data
{
    public class ApplicationDbContext : IdentityDbContext
    {
        public DbSet<Account> Accounts { get; set; }
        public DbSet<ApplicationUser> ApplicationUsers { get; set; }
        public DbSet<Bill> Bills { get; set; }
        public DbSet<BillGroup> BillGroups { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<TransactionFile> Files { get; set; }
        public DbSet<Transaction> Transactions { get; set; }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite("Data Source=mmr.sqlite");
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());


            builder.Entity<Transaction>().HasOne(x => x.CreatedBy).WithMany(x => x.Transactions).OnDelete(DeleteBehavior.NoAction);
            builder.Entity<Bill>().HasOne(x => x.BillGroup).WithMany(x => x.Bills).OnDelete(DeleteBehavior.NoAction);
            builder.Entity<TransactionFile>().HasOne(x => x.Transaction).WithMany(x => x.Files).OnDelete(DeleteBehavior.NoAction);

            builder.Entity<Transaction>()
                .HasMany(x => x.Categories)
                .WithMany(x => x.Transactions)
                .UsingEntity<Dictionary<string, object>>(
                "Link_Category_Transaction",
                x => x.HasOne<Category>().WithMany().OnDelete(DeleteBehavior.Restrict),
                x => x.HasOne<Transaction>().WithMany().OnDelete(DeleteBehavior.Cascade)
                );

            builder.Entity<Bill>()
                .HasMany(x => x.Categories)
                .WithMany(x => x.Bills)
                .UsingEntity<Dictionary<string, object>>(
                "Link_Category_Bill",
                x => x.HasOne<Category>().WithMany().OnDelete(DeleteBehavior.Restrict),
                x => x.HasOne<Bill>().WithMany().OnDelete(DeleteBehavior.Cascade)
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

            BillGroup billGroup_BigPaycheck = new()
            {
                Name = "Big Paycheck"
            };

            builder.Entity<BillGroup>().HasData(billGroup_BigPaycheck);

            Bill bill_Google = new()
            {
                Name = "Google",
                Amount = -6.40M,
                BillGroupId = billGroup_BigPaycheck.Id
            };

            builder.Entity<Bill>().HasData(bill_Google);

            decimal currentBalance = 0M;
            decimal outstandingBalance = 0M;
            decimal transAmount = -0M;
            int outstandingItemsCount = 0;

            transAmount = 1998M;
            currentBalance += transAmount;
            Transaction trans1 = new()
            {
                AccountId = account_Cash.Id,
                Amount = transAmount,
                Balance = 1998M,
                CreatedById = adminUser.Id,
                Name = "Payday",
                TransactionPendingUTC = DateTime.UtcNow.AddDays(-14),
                TransactionClearedUTC = DateTime.UtcNow.AddDays(-14),
                TransactionType = Transaction.EntryType.Credit
            };

            builder.Entity<Transaction>().HasData(trans1);

            transAmount = -bill_Google.Amount;
            currentBalance -= transAmount;
            outstandingBalance -= transAmount;
            outstandingItemsCount++;
            Transaction trans2 = new()
            {
                AccountId = account_Cash.Id,
                Amount = bill_Google.Amount,
                Balance = currentBalance,
                CreatedById = adminUser.Id,
                Name = "Google",
                BillId = bill_Google.Id,
                TransactionType = Transaction.EntryType.Debit
            };

            builder.Entity<Transaction>().HasData(trans2);

            account_Cash.CurrentBalance = currentBalance;
            account_Cash.OutstandingBalance = outstandingBalance;
            account_Cash.OutstandingItemCount = outstandingItemsCount;
            builder.Entity<Account>().HasData(account_Cash);

        }
    }
}