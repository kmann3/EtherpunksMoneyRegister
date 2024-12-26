using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

/// <summary>
/// A method of grouping transactions together in a way to sort or identify recurring groups - such as gas, groceries
/// </summary>
public class Category : BasicTable<Category>, IEntityTypeConfiguration<Category>
{
    [JsonIgnore]
    public List<Transaction> Transactions { get; set; }

    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; set; }

    public override void Configure(EntityTypeBuilder<Category> builder)
    {

    }
}
