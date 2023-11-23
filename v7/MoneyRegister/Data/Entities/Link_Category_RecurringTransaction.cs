using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

public class Link_Category_RecurringTransaction
{
    public Guid CategoryId { get; set; }
    public Guid RecurringTransactionId { get; set; }

    [JsonIgnore]
    public Category Category { get; set; } = null!;
    [JsonIgnore]
    public RecurringTransaction RecurringTransaction { get; set; } = null!;
}
