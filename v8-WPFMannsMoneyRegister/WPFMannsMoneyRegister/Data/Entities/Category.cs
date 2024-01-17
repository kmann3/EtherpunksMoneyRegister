using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Text.Json.Serialization;
using WPFMannsMoneyRegister.Data.Entities.Base;

namespace WPFMannsMoneyRegister.Data.Entities;
/// <summary>
/// A method of grouping transactions together in a way to sort or identify recurring groups - such as gas, groceries
/// </summary>
public class Category : BasicTable<Category>, IEntityTypeConfiguration<Category>
{
    [JsonIgnore]
    public List<Link_Category_Transaction> Link_Category_Transactions { get; } = new();

    [JsonIgnore]
    public List<Transaction> Transactions { get; } = new();

    [JsonIgnore]
    public List<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; } = new();

    [JsonIgnore]
    public List<RecurringTransaction> RecurringTransactions { get; } = new();

    public override void Configure(EntityTypeBuilder<Category> builder)
    {
    }
}