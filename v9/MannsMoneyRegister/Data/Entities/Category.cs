using MannsMoneyRegister.Data.Entities.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;
/// <summary>
/// A method of grouping transactions together in a way to sort or identify recurring groups - such as gas, groceries
/// </summary>
public class Category : BasicTable<Category>, IEntityTypeConfiguration<Category>
{
    [JsonIgnore]
    public List<Link_Category_Transaction> Link_Category_Transactions { get; } = [];

    [JsonIgnore]
    public List<AccountTransaction> AccountTransactions { get; } = [];

    [JsonIgnore]
    public List<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; } = [];

    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; } = [];

    public override void Configure(EntityTypeBuilder<Category> builder)
    {
    }
}