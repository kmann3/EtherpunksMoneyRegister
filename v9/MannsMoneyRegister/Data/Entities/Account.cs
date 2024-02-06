using MannsMoneyRegister.Data.Entities.Base;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MannsMoneyRegister.Data.Entities;

public class Account : BasicTable<Account>, IEntityTypeConfiguration<Account>
{
    [Precision(18, 2)]
    public decimal StartingBalance { get; set; } = 0M;

    [Precision(18, 2)]
    public decimal CurrentBalance { get; set; } = 0M;

    [Precision(18, 2)]
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

    public string AccountNumber { get; set; } = string.Empty;

    [Precision(18, 2)]
    public decimal InterestRate { get; set; } = 0M;

    public string Notes { get; set; } = string.Empty;

    public string LoginUrl { get; set; } = string.Empty;

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
    public List<AccountTransaction> AccountTransactions { get; set; } = [];

    // TODO: Account Types? Liability, Assets?

    public override void Configure(EntityTypeBuilder<Account> builder)
    {
    }
}