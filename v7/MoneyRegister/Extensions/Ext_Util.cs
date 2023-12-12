namespace MoneyRegister.Extensions;

public static class Ext_Util
{
    public static DateTime? ToLocal(this DateTime? value, string localTime)
    {
        if (value == null) return null;
        //Central Standard Time
        TimeZoneInfo timeZone = TimeZoneInfo.FindSystemTimeZoneById(localTime);
        return TimeZoneInfo.ConvertTimeFromUtc(value.Value, timeZone);
    }

    public static DateTime ToLocal(this DateTime value, string localTime)
    {
        //Central Standard Time
        TimeZoneInfo timeZone = TimeZoneInfo.FindSystemTimeZoneById(localTime);
        return TimeZoneInfo.ConvertTimeFromUtc(value, timeZone);
    }

    ///<summary>Gets the first week day following a date.</summary>
    ///<param name="date">The date.</param>
    ///<param name="dayOfWeek">The day of week to return.</param>
    ///<returns>The first dayOfWeek day following date, or date if it is on dayOfWeek.</returns>
    public static DateTime Next(this DateTime date, DayOfWeek dayOfWeek)
    {
        return date.AddDays((dayOfWeek < date.DayOfWeek ? 7 : 0) + dayOfWeek - date.DayOfWeek);
    }

    public static DateTime GetNthWeekofMonth(DateTime date, int nthWeek, DayOfWeek dayOfWeek)
    {
        // Let's sanitize this just in case a DateTime.Now was passed - let's reset this to the first of the month.
        date = new DateTime(date.Year, date.Month, 1);
        return date.Next(dayOfWeek).AddDays((nthWeek - 1) * 7);
    }
}