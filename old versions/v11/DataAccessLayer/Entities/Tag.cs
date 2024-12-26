using EtherpunksMoneyRegister_DAL.Entities.Base;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

namespace EtherpunksMoneyRegister_DAL.Entities;

/// <summary>
/// A method of grouping transactions together in a way to sort or identify recurring groups - such as gas, groceries
/// </summary>
public class Tag : BasicTable<Tag>, IEntityTypeConfiguration<Tag>
{
    [JsonIgnore]
    public List<Link_Tag_Transaction> Link_Tag_Transactions { get; } = [];

    [JsonIgnore]
    public List<AccountTransaction> AccountTransactions { get; } = [];

    [JsonIgnore]
    public List<Link_Tag_RecurringTransaction> Link_Tag_RecurringTransactions { get; } = [];

    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; } = [];

    public override void Configure(EntityTypeBuilder<Tag> builder)
    {
    }
}