namespace MoneyRegister.Data.DataGridDTO;

public class GridDataRequestDto
{
    public Guid AccountId { get; set; }
    /// <summary>
    /// The page number for the data we're requesting.
    /// </summary>
    public int Page { get; set; } = 0;

    /// <summary>
    /// Number of items per page
    /// </summary>
    public int PageSize { get; set;} = 10;
}
