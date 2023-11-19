using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

public class Account : BasicTable<Account>, IEntityTypeConfiguration<Account>
{
    //public Company Company { get; set; }
    //public Guid CompanyId { get; set; }

    [Precision(18, 2)]
    public decimal StartingBalance { get; set; } = 0M;

    [Precision(18, 2)]
    /// <summary>
    /// Pre-calculate balance; This is to help speed up dashboard views
    /// </summary>
    public decimal CurrentBalance { get; set; } = 0M;

    [Precision(18, 2)]
    /// <summary>
    /// Pre-calculated outstanding balance; This is to help speed up dashboard views
    /// </summary>
    public decimal OutstandingBalance { get; set; } = 0M;

    /// <summary>
    /// Pre-calculated outstanding item counts; This is to help speed up dashboard views
    /// </summary>
    public int OutstandingItemCount { get; set; } = 0;

    public string OutstandingSummary
    {
        get
        {
            return $"{OutstandingItemCount} item{(OutstandingItemCount != 1 ? "s" : "")} | {OutstandingBalance:C}";
        }
    }

    public string AccountNumber { get; set; } = String.Empty;

    [Precision(18, 2)]
    public decimal InterestRate { get; set; } = 0M;

    public string Notes { get; set; } = String.Empty;

    public string LoginUrl { get; set; } = String.Empty;

    public DateTime LastBalancedUTC { get; set; } = DateTime.MinValue;
    [NotMapped]
    [JsonIgnore]
    public DateTime LastBalancedLocalTime
    {
        get
        {
            return LastBalancedUTC.ToLocalTime();
        }
        set
        {
            LastBalancedUTC = value.ToUniversalTime();
        }
    }

    [JsonIgnore]
    public List<Transaction> Transactions { get; set; }
    // TODO: Account Types? Liability, Assets?

    public override void Configure(EntityTypeBuilder<Account> builder)
    {

    }
}
