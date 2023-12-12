using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

/// <summary>
/// Individual transactions for associated accounts.
/// </summary>
public class Transaction : BasicTable<Transaction>, IEntityTypeConfiguration<Transaction>, IComparer<Transaction>
{
    /// <summary>
    /// This is the literal bank line - the one that's not shortened.
    /// Example: CA 408 536 6000 ADOBE / Withdrawal @ CA 408 536 6000 ADOBE *PHOTOGPHY PUSADOBE *PHOTOGPH Trace #70108
    /// </summary>
    public string LiteralTransactionText = string.Empty;

    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Amount { get; set; }

    [JsonIgnore]
    public Account Account { get; set; }
    public Guid AccountId { get; set; }

    [Display(Name = "Transaction Pending")]
    public DateTime? TransactionPendingUTC { get; set; } = null;

    [NotMapped]
    [JsonIgnore]
    public DateTime? TransactionPendingLocalTime
    {
        get
        {
            return TransactionPendingUTC.HasValue == true ? TransactionPendingUTC.Value.ToLocalTime() : null;
        }
        set
        {
            TransactionPendingUTC = value.HasValue == true ? value.Value.ToUniversalTime() : null;
        }
    }

    [Display(Name = "Transaction Cleared")]
    public DateTime? TransactionClearedUTC { get; set; } = null;

    [NotMapped]
    [JsonIgnore]
    public DateTime? TransactionClearedLocalTime
    {
        get
        {
            return TransactionClearedUTC.HasValue == true ? TransactionClearedUTC.Value.ToLocalTime() : null;
        }
        set
        {
            TransactionClearedUTC = value.HasValue == true ? value.Value.ToUniversalTime() : null;
        }
    }

    /// <summary>
    /// Decimal.Parse(value)
    /// Balance = value.ToString("0.00")
    /// </summary>
    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Balance { get; set; } = 0M;

    public string Notes { get; set; } = string.Empty;

    [JsonIgnore]
    public List<Link_Category_Transaction> Link_Category_Transactions { get; } = new List<Link_Category_Transaction>();
    [JsonIgnore]
    public List<Category> Categories { get; set; } = new();
    [JsonIgnore]

    public List<TransactionFile> Files { get; set; } = new();

    [JsonIgnore]
    public RecurringTransaction? RecurringTransaction { get; set; }
    public Guid? RecurringTransactionId { get; set; }
    [JsonIgnore]

    public Lookup_TransactionType TransactionTypeLookup { get; set; }
    public Guid TransactionTypeLookupId { get; set; }

    public int Compare(Transaction? x, Transaction? y)
    {
        // If they are null, they are equal. This should never happen. All transactions should have some data.
        if (x == null || y == null) return 0;

        // If both have no transaction dates, then compare names.
        if ((x.TransactionPendingUTC == null && x.TransactionClearedUTC == null) && (y.TransactionPendingUTC == null && y.TransactionClearedUTC == null))
        {
            return String.Compare(x.Name, y.Name, StringComparison.OrdinalIgnoreCase);
        }

        // if BOTH have cleared dates then do a simple date.compare
        if (x.TransactionClearedUTC.HasValue && y.TransactionClearedUTC.HasValue)
        {
            return DateTime.Compare(y.CreatedOnUTC, x.CreatedOnUTC);
        }

        // if one has a cleared date then that one wins
        if (x.TransactionClearedUTC.HasValue)
        {
            return 1;
        }
        else if (y.TransactionClearedUTC.HasValue)
        {
            return -1;
        }

        // if both have entered dates, do a simple compare
        if (x.TransactionPendingUTC.HasValue && y.TransactionPendingUTC.HasValue)
        {
            return DateTime.Compare(y.CreatedOnUTC, x.CreatedOnUTC);
        }

        // if one has entered date then that one ones.
        if (x.TransactionPendingUTC.HasValue)
        {
            return 1;
        }
        else if (y.TransactionPendingUTC.HasValue)
        {
            return -1;
        }

        // if we end up here, throw an exception. Clearly I missed an area.

        throw new NotImplementedException();
    }

    // TBI: Implement file attachments (e.g. pictures of receipts)

    public override void Configure(EntityTypeBuilder<Transaction> builder)
    {

    }
    public void VerifySignage()
    {
        this.Amount = this.TransactionTypeLookup.Name switch
        {
            "Credit" => Math.Abs(this.Amount),
            "Debit" => -Math.Abs(this.Amount),
            _ => throw new NotImplementedException(),
        };
    }
}
