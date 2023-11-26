namespace MoneyRegister.Data.Entities;

public class MR_Enum
{
    public enum Regularity
    {
        /// <summary>
        /// A specific day of the month
        /// </summary>
        Monthly = 3,

        /// <summary>
        /// Every X days, such as every 30 days or every 28 days (many credit card companies do this)
        /// </summary>
        XDays = 4,

        /// <summary>
        /// Every x weeks
        /// </summary>
        XWeeks = 5,

        /// <summary>
        /// Every X months
        /// </summary>
        XMonths = 6,

        /// <summary>
        /// Example: "3rd Wednesday of the month"
        /// </summary>
        XWeekYDayOfWeek = 7,

        /// <summary>
        /// Every X day of week
        /// </summary>
        Weekly = 8,

        /// <summary>
        /// Yearly recurrence
        /// </summary>
        Annually = 2,

        /// <summary>
        /// This could be something that happens on a basis that's not exactly predictable - such as bug sprays where it's a rough time area
        /// </summary>
        Nonregular = 1,

        /// <summary>
        /// It's recurring but you don't know.
        /// </summary>
        Unknown = 0
    }

    public enum TransactionType
    {
        Credit = 0,
        Debit = 1
    }
}
