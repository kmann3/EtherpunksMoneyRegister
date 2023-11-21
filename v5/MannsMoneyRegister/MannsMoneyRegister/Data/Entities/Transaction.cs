using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

public class Transaction : BasicTable<Transaction>, IEntityTypeConfiguration<Transaction>, IComparer<Transaction>
{
    [Precision(18, 2)]
    public decimal Amount { get; set; } = 0M;

    [JsonIgnore]
    public Account? Account { get; set; }
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
        } set
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

    public List<Category> Categories { get; set; }

    public List<TransactionFile> Files { get; set; }

    [JsonIgnore]
    public Bill? Bill { get; set; }
    public Guid? BillId { get; set; }

    public EntryType TransactionType { get; set; }
    public enum EntryType
    {
        /// <summary>
        /// Debits always are a negative number
        /// </summary>
        Debit,

        /// <summary>
        /// Credits are always a positive number
        /// </summary>
        Credit
    }

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
}
