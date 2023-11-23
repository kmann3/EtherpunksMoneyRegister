namespace MoneyRegister.Data.Entities;

public class Link_Category_Transaction
{
    public Guid CategoryId { get; set; }
    public Category Category { get; set; } = null!;
    public Guid TransactionId { get; set; }
    public Transaction Transaction { get; set; } = null!;
}
