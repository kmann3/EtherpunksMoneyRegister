using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace DataAccessLayer
{
    public class EMRDbContext : DbContext
    {
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
