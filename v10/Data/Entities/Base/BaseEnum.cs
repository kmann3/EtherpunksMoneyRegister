namespace MannsMoneyRegister.Data.Entities.Base;

public class Enums
{
    public enum TransactionTypeEnum
    {
        Credit,
        Debit,
    }

    public enum RecurringFrequencyTypeEnum
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

    public static IEnumerable<TransactionTypeEnum> GetTransactionTypeEnums
    {
        get
        {
            return Enum.GetValues(typeof(TransactionTypeEnum)).Cast<TransactionTypeEnum>();
        }
    }
}
