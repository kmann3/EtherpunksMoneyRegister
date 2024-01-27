using System.Globalization;
using System.Windows.Data;

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

    public static IEnumerable<TransactionType> GetTransactionTypeEnums
    {
        get
        {
            return Enum.GetValues(typeof(TransactionType)).Cast<TransactionType>();
        }
    }
}
