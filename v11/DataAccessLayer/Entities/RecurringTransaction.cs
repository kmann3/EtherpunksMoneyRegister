using EtherpunksMoneyRegister_DAL.Entities.Base;
using Humanizer;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;


namespace EtherpunksMoneyRegister_DAL.Entities;

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

    /// <summary>
    /// This is the literal bank line - the one that's not shortened.
    /// Example: CA 408 536 6000 ADOBE / Withdrawal @ CA 408 536 6000 ADOBE *PHOTOGPHY PUSADOBE *PHOTOGPH Trace #70108
    /// </summary>
    public string BankTransactionText { get; set; } = string.Empty;
    /// <summary>
    /// A regex match
    /// </summary>
    public string BankTransactionRegEx { get; set; } = string.Empty;

    [JsonIgnore]
    public List<Link_Tag_RecurringTransaction> Link_Tag_RecurringTransactions { get; } = [];

    [JsonIgnore]
    public List<Tag> Tags { get; set; } = [];

    public Enums.RecurringFrequencyTypeEnum RecurringFrequencyType { get; set; } = Enums.RecurringFrequencyTypeEnum.Unknown;

    /// <summary>
    /// Test all of these.
    /// </summary>
    [NotMapped]
    public string RecurringFrequencyTypeString
    {
        get
        {
            return RecurringFrequencyType switch
            {
                Enums.RecurringFrequencyTypeEnum.Yearly => $"Yearly on {FrequencyDateValue!.Value:MMM} {FrequencyDateValue.Value.Day.ToString().Ordinalize()}", // TBI: I need to test this.
                Enums.RecurringFrequencyTypeEnum.Monthly => $"{FrequencyDateValue!.Value.Day.ToString().Ordinalize()} of the month",
                Enums.RecurringFrequencyTypeEnum.Weekly => $"Every {FrequencyDayOfWeekValue}",
                Enums.RecurringFrequencyTypeEnum.XMonths => $"Every {FrequencyValue} month{(FrequencyValue == 1 ? "" : "s")} on the {FrequencyDateValue!.Value.Day.ToString().Ordinalize()}",
                Enums.RecurringFrequencyTypeEnum.XDays => $"Every {FrequencyValue} day{(FrequencyValue == 1 ? "" : "s")}",
                Enums.RecurringFrequencyTypeEnum.XWeekOnYDayOfWeek => $"Every {FrequencyValue.ToString().Ordinalize()} {FrequencyDayOfWeekValue}",
                Enums.RecurringFrequencyTypeEnum.Irregular => $"Irregular",
                Enums.RecurringFrequencyTypeEnum.Unknown => $"Unknown",
                _ => throw new NotImplementedException()
            };
        }
    }

    /// <summary>
    /// This is a number assigned for frequency calculations
    /// Monthly: FrequencyValue is the day of the month
    /// XMonths: FrequencyValue how many months to skip, such as every other month if given 2. FrequencyDateValue's DAY is used to know which day.
    /// XDays: How many days to skip.
    /// XWeekOnYDayOfWeek: FrequencyValue is used to know which week. DayOfWeek tells us which day.
    /// </summary>
    public int? FrequencyValue { get; set; } = null;

    /// <summary>
    /// This is the day of week used for frequency calculations
    /// Weekly: Day of week.
    /// XWeekOnYDayOfWeek: DayOfWeek tells us which day. FrequencyValue is used to know which week. 
    /// </summary>
    public DayOfWeek? FrequencyDayOfWeekValue { get; set; } = null;

    /// <summary>
    /// Date used for Frequency calculations. We use DateTime because that's what MudBlazor requires. For further information: https://github.com/MudBlazor/MudBlazor/issues/6178
    /// Yearly: Day/month of the year is used. All other aspects of this datatype are ignored.
    /// Monthly: Day of the month is used.
    /// XMonths: XMonths: FrequencyDateValue's DAY is used to know which day. FrequencyValue how many months to skip, such as every other month if given 2. 
    /// </summary>
    public DateTime? FrequencyDateValue { get; set; } = null;

    [JsonIgnore]
    public RecurringTransactionGroup? Group { get; set; }

    public Guid? RecurringTransactionGroupId { get; set; }


    public Enums.TransactionTypeEnum TransactionType { get; set; }

    [JsonIgnore]
    public List<AccountTransaction> PreviousAccountTransactions { get; set; }

    public override void Configure(EntityTypeBuilder<RecurringTransaction> builder)
    {
        //builder.HasIndex(k => k.Name).IsUnique(true);
    }

    public void BumpNextDueDate()
    {
        // If we don't know a due date at all then we can't calculate the next one.
        if (NextDueDate == null) return;

        switch (RecurringFrequencyType)
        {
            case Enums.RecurringFrequencyTypeEnum.Unknown:
                break;
            case Enums.RecurringFrequencyTypeEnum.Irregular:
                break;
            case Enums.RecurringFrequencyTypeEnum.Yearly:
                NextDueDate = NextDueDate.Value.AddYears(1);
                break;
            case Enums.RecurringFrequencyTypeEnum.Monthly:
                NextDueDate = NextDueDate.Value.AddMonths(1);
                break;
            case Enums.RecurringFrequencyTypeEnum.Weekly:
                NextDueDate = NextDueDate.Value.AddDays(7);
                break;
            case Enums.RecurringFrequencyTypeEnum.XDays:
                NextDueDate = NextDueDate.Value.AddDays(FrequencyValue ?? throw new Exception($"Missing Frequency Value for Recurring Transaction: {this}"));
                break;
            case Enums.RecurringFrequencyTypeEnum.XMonths:
                NextDueDate = NextDueDate.Value.AddMonths(FrequencyValue ?? throw new Exception($"Missing Frequency Value for Recurring Transaction: {this}"));
                break;
            case Enums.RecurringFrequencyTypeEnum.XWeekOnYDayOfWeek:
                NextDueDate = NextDueDate.Value.AddMonths(1);
                NextDueDate = DayOccurrence(NextDueDate.Value.Year, NextDueDate.Value.Month, FrequencyDayOfWeekValue ?? throw new Exception($"Missing FrequencyDayOfWeekValue in {this}"), FrequencyValue ?? throw new Exception($"Missing Frequency Value in {this}"));
                break;
            default:
                break;
        }
    }

    /// Source: https://stackoverflow.com/a/2827757/18217
    private static DateTime DayOccurrence(int year, int month, DayOfWeek day, int occurrenceNumber)
    {
        DateTime start = new(year, month, 1);
        DateTime first = start.AddDays((7 - ((int)start.DayOfWeek - (int)day)) % 7);

        return first.AddDays(7 * (occurrenceNumber - 1));
    }

    public void VerifySignage()
    {
        Amount = TransactionType switch
        {
            Enums.TransactionTypeEnum.Credit => Math.Abs(Amount),
            Enums.TransactionTypeEnum.Debit => -Math.Abs(Amount),
            _ => throw new Exception($"Unknown case: {TransactionType}"),
        };
    }
}
