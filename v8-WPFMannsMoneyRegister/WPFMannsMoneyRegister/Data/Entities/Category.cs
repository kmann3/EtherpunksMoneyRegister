using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Collections.ObjectModel;
using System.Text.Json.Serialization;
using WPFMannsMoneyRegister.Data.Entities.Base;

namespace WPFMannsMoneyRegister.Data.Entities;
/// <summary>
/// A method of grouping transactions together in a way to sort or identify recurring groups - such as gas, groceries
/// </summary>
public class Category : BasicTable<Category>, IEntityTypeConfiguration<Category>
{
    [JsonIgnore]
    public ObservableCollection<Link_Category_Transaction> Link_Category_Transactions { get; } = new();

    [JsonIgnore]
    public ObservableCollection<AccountTransaction> AccountTransactions { get; } = new();

    [JsonIgnore]
    public ObservableCollection<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; } = new();

    [JsonIgnore]
    public ObservableCollection<RecurringTransaction> RecurringTransactions { get; } = new();

    public override void Configure(EntityTypeBuilder<Category> builder)
    {
    }
}