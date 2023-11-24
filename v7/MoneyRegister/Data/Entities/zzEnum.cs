namespace MoneyRegister.Data.Entities;

public class MR_Enum
{
    public enum Regularity
    {
        /// <summary>
        /// A specific day of the month
        /// </summary>
        Monthly,

        /// <summary>
        /// Every X days, such as every 30 days or every 28 days (many credit card companies do this)
        /// </summary>
        XDays,

        /// <summary>
        /// Example: "3rd Wednesday of the month"
        /// </summary>
        XWeekYDayOfWeek,

        /// <summary>
        /// Yearly recurrance
        /// </summary>
        Annually,

        /// <summary>
        /// This could be something that happens on a basis that's not exactly predictable - such as bug sprays where it's a rough time area
        /// </summary>
        Nonregular,

        /// <summary>
        /// It's recurring but you don't know.
        /// </summary>
        Unknown
    }

    public enum TransactionType
    {
        Credit,
        Debit
    }
}
