﻿using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

/// <summary>
/// Transactions that occur with a regularity and should be displayed uniquely from normal transactions
/// </summary>
public class RecurringTransaction : BasicTable<RecurringTransaction>, IEntityTypeConfiguration<RecurringTransaction>
{
    public DateTime? NextDueDate { get; set; } = null;

    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Amount { get; set; } = 0M;
    public string Notes { get; set; } = string.Empty;
    public List<Category> Categories { get; set; }

    public MMR_Enum.Regularity Frequency { get; set; } = MMR_Enum.Regularity.Unknown;

    public int? FrequencyValue { get; set; } = null;
    public DayOfWeek? DayOfWeekValue { get; set; } = null;
    [JsonIgnore]
    public TransactionGroup? Group { get; set; }
    public Guid? TransactionGroupId { get; set; }
    public MMR_Enum.TransactionType TransactionType { get; set; }
    // TODO: What about when the date falls on a weekend?
    // TODO: What if we want to transfer from one account to another? TransactionType? Or Debit+Credit?

    public override void Configure(EntityTypeBuilder<RecurringTransaction> builder)
    {
        //builder.HasIndex(k => k.Name).IsUnique(true);
    }
}
