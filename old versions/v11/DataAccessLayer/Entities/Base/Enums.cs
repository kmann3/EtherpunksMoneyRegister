namespace EtherpunksMoneyRegister_DAL.Entities.Base;

/// <summary>
/// Enums used by the application
/// </summary>
public class Enums
{
    /// <summary>
    /// The type of transaction.
    /// Credit - add money
    /// Debit - substract money
    /// </summary>
    public enum TransactionTypeEnum
    {
        Credit,
        Debit,
    }

    /// <summary>
    /// Recurring Frequency is used for recurring transactions
    /// </summary>
    public enum RecurringFrequencyTypeEnum
    {
        /// <summary>
        /// Unknown frequency. This is usually simply a placeholder.
        /// </summary>
        Unknown,

        /// <summary>
        /// Irregular means you will add it manually and simply want it in the list
        /// </summary>
        Irregular,
        Yearly,
        Monthly,
        Weekly,

        /// <summary>
        /// Every X days. Useful for some transactions that are every 30 days and not monthly
        /// </summary>
        XDays,
        XMonths,

        /// <summary>
        /// Every X week on Y day.
        /// This could be something like every 4'th week on a Wednesday
        /// </summary>
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