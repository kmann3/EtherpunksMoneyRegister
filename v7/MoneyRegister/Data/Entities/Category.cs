using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

/// <summary>
/// A method of grouping transactions together in a way to sort or identify recurring groups - such as gas, groceries
/// </summary>
public class Category : BasicTable<Category>, IEntityTypeConfiguration<Category>
{
    //[JsonIgnore]
    //public List<Transaction> Transactions { get; set; } = new();

    [JsonIgnore]
    public List<Link_Category_Transaction> CategoryTransactions { get; } = new();

    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; set; } = new();

    public override void Configure(EntityTypeBuilder<Category> builder)
    {

    }
}
