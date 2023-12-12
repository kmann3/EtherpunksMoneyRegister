using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

public class Lookup_TransactionType : BasicTable<Lookup_TransactionType>, IEntityTypeConfiguration<Lookup_TransactionType>
{
    public int Ordinal { get; set; } = 0;
    public string DisplayString { get; set; } = string.Empty;
    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; set; }
    [JsonIgnore]
    public List<Transaction> Transactions { get; set; }
    public enum LookupTypeEnum
    {
        TransactionType,
        RecurringTransactionFrequency
    }
    public override void Configure(EntityTypeBuilder<Lookup_TransactionType> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }
}
