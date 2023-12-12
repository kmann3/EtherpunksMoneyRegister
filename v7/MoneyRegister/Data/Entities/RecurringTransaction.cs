using Humanizer;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

/// <summary>
/// Transactions that occur with a regularity and should be displayed uniquely from normal transactions
/// </summary>
public class RecurringTransaction : BasicTable<RecurringTransaction>, IEntityTypeConfiguration<RecurringTransaction>
{
    public DateTime? NextDueDate { get; set; } = null;

    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Amount { get; set; }

    public string Notes { get; set; } = string.Empty;

    [JsonIgnore]
    public List<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; } = new();

    [JsonIgnore]
    public List<Category> Categories { get; set; } = new();

    public Lookup_RecurringTransactionFrequency FrequencyLookup { get; set; }
    public Guid FrequencyLookupId { get; set; }

    [NotMapped]
    public string FrequencyString
    {
        get
        {
            try
            {
                switch (FrequencyLookup.Name)
                {
                    case "Yearly":
                        return "Annually";

                    case "Monthly":
                        return $"{FrequencyValue.ToString().Ordinalize()} of the month";

                    case "Weekly":
                        return $"Every {FrequencyDayOfWeekValue}";

                    case "Irregular":
                        return "Irregular frequency";

                    case "XDays":
                        return $"Every {FrequencyValue} days";
                    // TBI Day/Days - calculate
                    case "XMonths":
                        return $"Every {FrequencyValue} months";

                    case "XWeekYDayOfWeek":
                        return $"Every {FrequencyValue.ToString().Ordinalize()} {FrequencyDayOfWeekValue}";

                    case "Unknown":
                        return "Unknown";

                    default:
                        throw new NotImplementedException();
                }
            }
            catch (Exception ex)
            {
                // Probably value in frequency is null but shouldn't be. This should only be hit when I messing with the DB manually and broke something
                return $"ERROR: {ex}";
            }
        }
    }

    public int? FrequencyValue { get; set; } = null;
    public DayOfWeek? FrequencyDayOfWeekValue { get; set; } = null;
    public DateTime? FrequencyDateValue { get; set; } = null;

    [JsonIgnore]
    public TransactionGroup? Group { get; set; }

    public Guid? TransactionGroupId { get; set; }

    [JsonIgnore]
    public Lookup_TransactionType TransactionTypeLookup { get; set; }

    public Guid TransactionTypeLookupId { get; set; }

    [JsonIgnore]
    public List<Transaction> PreviousTransactions { get; set; }

    // TODO: What about when the date falls on a weekend?
    // TODO: What if we want to transfer from one account to another? TransactionType? Or Debit+Credit?

    public override void Configure(EntityTypeBuilder<RecurringTransaction> builder)
    {
        //builder.HasIndex(k => k.Name).IsUnique(true);
    }

    public void BumpNextDueDate()
    {
        if (this.NextDueDate == null) return;

        switch (this.FrequencyLookup.Name)
        {
            case "Yearly":
                this.NextDueDate = this.NextDueDate.Value.AddYears(1);
                break;

            case "Monthly":
                this.NextDueDate = this.NextDueDate.Value.AddMonths(1);
                break;

            case "Weekly":
                this.NextDueDate = this.NextDueDate.Value.AddDays(7);
                break;

            case "XDays":
                this.NextDueDate = this.NextDueDate.Value.AddDays(this.FrequencyValue ?? throw new Exception($"Missing Frequency Value for Recurring Transaction: {this}"));
                break;

            case "XMonths":
                this.NextDueDate = this.NextDueDate.Value.AddMonths(this.FrequencyValue ?? throw new Exception($"Missing Frequency Value for Recurring Transaction: {this}"));
                break;

            case "XWeekYDayOfWeek":
                this.NextDueDate = this.NextDueDate.Value.AddMonths(1);
                this.NextDueDate = DayOccurrence(this.NextDueDate.Value.Year, this.NextDueDate.Value.Month, this.FrequencyDayOfWeekValue ?? throw new Exception($"Missing FrequencyDayOfWeekValue in {this}"), this.FrequencyValue ?? throw new Exception($"Missing Frequency Value in {this}"));
                break;

            case "Irregular":
            case "Unknown":
                break;

            default:
                throw new Exception($"Unknown Lookup value: {this.FrequencyLookup}");
        }
    }

    /// Source: https://stackoverflow.com/a/2827757/18217
    private static DateTime DayOccurrence(int year, int month, DayOfWeek day, int occurrenceNumber)
    {
        DateTime start = new DateTime(year, month, 1);
        DateTime first = start.AddDays((7 - ((int)start.DayOfWeek - (int)day)) % 7);

        return first.AddDays(7 * (occurrenceNumber - 1));
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