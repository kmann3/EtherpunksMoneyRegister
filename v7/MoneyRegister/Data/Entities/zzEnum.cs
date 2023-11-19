namespace MoneyRegister.Data.Entities;

public class MR_Enum
{
    public enum Regularity
    {
        Monthly,
        XDays, // Can also calculate this to weekly
        XWeekYDayOfWeek,
        Annually,
        Nonregular,
        Unknown
    }

    public enum TransactionType
    {
        Credit,
        Debit
    }
}
