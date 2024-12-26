using EtherpunksMoneyRegister_DAL.Entities.Base;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

namespace EtherpunksMoneyRegister_DAL.Entities;

public class RecurringTransactionGroup : BasicTable<RecurringTransactionGroup>, IEntityTypeConfiguration<RecurringTransactionGroup>
{
    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; set; } = [];

    public override void Configure(EntityTypeBuilder<RecurringTransactionGroup> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }
}