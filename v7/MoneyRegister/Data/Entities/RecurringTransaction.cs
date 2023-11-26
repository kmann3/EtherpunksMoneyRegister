using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;
using System.ComponentModel.DataAnnotations.Schema;
using Humanizer;

namespace MoneyRegister.Data.Entities;

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

    [JsonIgnore]
    public List<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; } = new();
    [JsonIgnore]
    public List<Category> Categories { get; } = new();
    public MR_Enum.Regularity Frequency { get; set; } = MR_Enum.Regularity.Unknown;
    [NotMapped]
    public string FrequencyString
    {
        get
        {
            try
            {
                switch (Frequency)
                {
                    case MR_Enum.Regularity.Annually:
                        return "Annually";
                    case MR_Enum.Regularity.Monthly:
                        return $"{FrequencyValue.ToString().Ordinalize()} of the month";
                    case MR_Enum.Regularity.Nonregular:
                        return "Nonregular frequency";
                    case MR_Enum.Regularity.XDays:
                        return $"Every {FrequencyValue} days";
                    case MR_Enum.Regularity.XWeekYDayOfWeek:
                        return $"Every {FrequencyValue.ToString().Ordinalize()} {DayOfWeekValue}";
                    case MR_Enum.Regularity.Weekly:
                        return $"Every {DayOfWeekValue}";
                    case MR_Enum.Regularity.Unknown:
                        return "Unknown";
                    default:
                        throw new NotImplementedException();
                }
            } catch (Exception ex)
            {
                // Probably value in frequncy is null but shouldn't be. This should only be hit when I messing with the DB manually and broke something
                return "ERROR";
            }
        }
    }

    public int? FrequencyValue { get; set; } = null;
    public DayOfWeek? DayOfWeekValue { get; set; } = null;
    public DateTime? FrequencyDateValue { get; set; } = null;
    [JsonIgnore]
    public TransactionGroup? Group { get; set; }
    public Guid? TransactionGroupId { get; set; }
    public MR_Enum.TransactionType TransactionType { get; set; } = MR_Enum.TransactionType.Debit;
    // TODO: What about when the date falls on a weekend?
    // TODO: What if we want to transfer from one account to another? TransactionType? Or Debit+Credit?

    public override void Configure(EntityTypeBuilder<RecurringTransaction> builder)
    {
        //builder.HasIndex(k => k.Name).IsUnique(true);
    }
}
