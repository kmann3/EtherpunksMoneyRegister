using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

public class Lookup_RecurringTransactionFrequency : BasicTable<Lookup_RecurringTransactionFrequency>, IEntityTypeConfiguration<Lookup_RecurringTransactionFrequency>
{
    public int Ordinal { get; set; } = 0;
    public string DisplayString { get; set; } = string.Empty;

    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; set; }

    public enum LookupTypeEnum
    {
        TransactionType,
        RecurringTransactionFrequency
    }

    public override void Configure(EntityTypeBuilder<Lookup_RecurringTransactionFrequency> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }
}