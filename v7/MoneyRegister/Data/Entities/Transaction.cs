using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MoneyRegister.Data.Entities.Base;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

/// <summary>
/// Individual transactions for associated accounts.
/// </summary>
public class Transaction : BasicTable<Transaction>, IEntityTypeConfiguration<Transaction>
{
    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Amount { get; set; }
    [JsonIgnore]
    public Account Account { get; set; }
    public Guid AccountId { get; set; }
    public Enums.TransactionType TransactionType { get; set; }
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
    public DateTime? DueDate { get; set; } = null;
    public string ConfirmationNumber { get; set; } = string.Empty;
    /// <summary>
    /// This is the literal bank line - the one that's not shortened.
    /// Example: CA 408 536 6000 ADOBE / Withdrawal @ CA 408 536 6000 ADOBE *PHOTOGPHY PUSADOBE *PHOTOGPH Trace #70108
    /// </summary>
    public string BankTransactionText = string.Empty;

    public override void Configure(EntityTypeBuilder<Transaction> builder)
    {
    }

    public void VerifySignage()
    {
        Amount = TransactionType switch
        {
            Enums.TransactionType.Credit => Math.Abs(Amount),
            Enums.TransactionType.Debit => -Math.Abs(Amount),
            _ => throw new Exception($"Unknown case: {TransactionType}"),
        };
    }
}