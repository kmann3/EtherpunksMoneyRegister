using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

/// <summary>
/// A group of transactions - such as a list of bills
/// </summary>
public class TransactionGroup : BasicTable<TransactionGroup>, IEntityTypeConfiguration<TransactionGroup>
{
    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; set; }

    public override void Configure(EntityTypeBuilder<TransactionGroup> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }
}
