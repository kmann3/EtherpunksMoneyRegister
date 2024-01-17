namespace WPFMannsMoneyRegister.Data.Entities.Base;
public class Enums
{
    public enum TransactionType
    {
        Credit,
        Debit,
    }

    public enum RecurringFrequencyType
    {
        Unknown,
        Irregular,
        Yearly,
        Monthly,
        Weekly,
        XDays,
        XMonths,
        XWeekOnYDayOfWeek
    }
}
