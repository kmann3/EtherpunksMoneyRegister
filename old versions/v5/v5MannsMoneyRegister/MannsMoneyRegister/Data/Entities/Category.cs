using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.Extensions.Hosting;
using System.Reflection.Emit;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

/// <summary>
/// Lookup for Account Types.
/// Prefix with Lookup to make knowing the lookup tables/methods easier.
/// </summary>
public class Category : BasicTable<Category>, IEntityTypeConfiguration<Category>
{
    [JsonIgnore]
    public List<Transaction> Transactions { get; set; }
    [JsonIgnore]
    public List<Bill> Bills { get; set; }

    public override void Configure(EntityTypeBuilder<Category> builder)
    {

    }    
}
