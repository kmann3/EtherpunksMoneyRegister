using System.Transactions;

namespace MoneyRegister.Data.DataGridDTO;

public class TransactionListDto
{
    public List<Data.Entities.Transaction> Items { get; set; } = new();

    /// <summary>
    /// Total count of items before paging
    /// </summary>
    public int ItemTotalCount { get; set; } = 0;
}
