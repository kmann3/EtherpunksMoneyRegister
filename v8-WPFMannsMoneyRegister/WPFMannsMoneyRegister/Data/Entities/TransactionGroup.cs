using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using WPFMannsMoneyRegister.Data.Entities.Base;
using System.Collections.ObjectModel;

namespace WPFMannsMoneyRegister.Data.Entities;
/// <summary>
/// A group of transactions - such as a list of bills
/// </summary>
public class TransactionGroup : BasicTable<TransactionGroup>, IEntityTypeConfiguration<TransactionGroup>
{
    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; set; } = new();

    public override void Configure(EntityTypeBuilder<TransactionGroup> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }
}