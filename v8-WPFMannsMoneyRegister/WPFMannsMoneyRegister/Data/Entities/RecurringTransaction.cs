using Humanizer;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using WPFMannsMoneyRegister.Data.Entities.Base;
using System.Collections.ObjectModel;

namespace WPFMannsMoneyRegister.Data.Entities;
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
    public ObservableCollection<Link_Category_RecurringTransaction> Link_Category_RecurringTransactions { get; } = new();

    [JsonIgnore]
    public ObservableCollection<Category> Categories { get; set; } = new();

    public Enums.RecurringFrequencyType RecurringFrequencyType { get; set; } = Enums.RecurringFrequencyType.Unknown;

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
                Enums.RecurringFrequencyType.Yearly => $"Yearly on {FrequencyDateValue!.Value:MMM} {FrequencyDateValue.Value.Day.ToString().Ordinalize()}", // TBI: I need to test this.
                Enums.RecurringFrequencyType.Monthly => $"{FrequencyDateValue!.Value.Day.ToString().Ordinalize()} of the month",
                Enums.RecurringFrequencyType.Weekly => $"Every {FrequencyDayOfWeekValue}",
                Enums.RecurringFrequencyType.XMonths => $"Every {FrequencyValue} month{(FrequencyValue == 1 ? "" : "s")} on the {FrequencyDateValue!.Value.Day.ToString().Ordinalize()}",
                Enums.RecurringFrequencyType.XDays => $"Every {FrequencyValue} day{(FrequencyValue == 1 ? "" : "s")}",
                Enums.RecurringFrequencyType.XWeekOnYDayOfWeek => $"Every {FrequencyValue.ToString().Ordinalize()} {FrequencyDayOfWeekValue}",
                Enums.RecurringFrequencyType.Irregular => $"Irregular",
                Enums.RecurringFrequencyType.Unknown => $"Unknown",
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
    public TransactionGroup? Group { get; set; }

    public Guid? TransactionGroupId { get; set; }


    public Enums.TransactionType TransactionType { get; set; }

    [JsonIgnore]
    public ObservableCollection<AccountTransaction> PreviousAccountTransactions { get; set; }

    public override void Configure(EntityTypeBuilder<RecurringTransaction> builder)
    {
        //builder.HasIndex(k => k.Name).IsUnique(true);
    }

    public void BumpNextDueDate()
    {
        // If we don't know a due date at all then we can't calculate the next one.
        if (this.NextDueDate == null) return;

        switch (RecurringFrequencyType)
        {
            case Enums.RecurringFrequencyType.Unknown:
                break;
            case Enums.RecurringFrequencyType.Irregular:
                break;
            case Enums.RecurringFrequencyType.Yearly:
                NextDueDate = NextDueDate.Value.AddYears(1);
                break;
            case Enums.RecurringFrequencyType.Monthly:
                NextDueDate = NextDueDate.Value.AddMonths(1);
                break;
            case Enums.RecurringFrequencyType.Weekly:
                NextDueDate = NextDueDate.Value.AddDays(7);
                break;
            case Enums.RecurringFrequencyType.XDays:
                NextDueDate = NextDueDate.Value.AddDays(FrequencyValue ?? throw new Exception($"Missing Frequency Value for Recurring Transaction: {this}"));
                break;
            case Enums.RecurringFrequencyType.XMonths:
                NextDueDate = NextDueDate.Value.AddMonths(FrequencyValue ?? throw new Exception($"Missing Frequency Value for Recurring Transaction: {this}"));
                break;
            case Enums.RecurringFrequencyType.XWeekOnYDayOfWeek:
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
            Enums.TransactionType.Credit => Math.Abs(Amount),
            Enums.TransactionType.Debit => -Math.Abs(Amount),
            _ => throw new Exception($"Unknown case: {TransactionType}"),
        };
    }
}