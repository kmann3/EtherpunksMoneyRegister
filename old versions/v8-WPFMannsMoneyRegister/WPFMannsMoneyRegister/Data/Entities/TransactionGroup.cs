using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Text.Json.Serialization;
using WPFMannsMoneyRegister.Data.Entities.Base;

namespace WPFMannsMoneyRegister.Data.Entities;
/// <summary>
/// A group of transactions - such as a list of bills
/// </summary>
public class TransactionGroup : BasicTable<TransactionGroup>, IEntityTypeConfiguration<TransactionGroup>
{
    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; set; } = [];

    public override void Configure(EntityTypeBuilder<TransactionGroup> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }
}