namespace MoneyRegister.Extensions;

/// <summary>
/// Extension methods are used here.
/// </summary>
public static class Ext_Util
{
    /// <summary>
    /// Converts UTC time to local time.
    /// </summary>
    /// <param name="value">Current date/time value</param>
    /// <param name="localTime">The time zone of the local machine.</param>
    /// <returns>Returns a datetime value of the local time.</returns>
    public static DateTime? ToLocal(this DateTime? value, string localTime)
    {
        if (value == null) return null;
        TimeZoneInfo timeZone = TimeZoneInfo.FindSystemTimeZoneById(localTime);
        return TimeZoneInfo.ConvertTimeFromUtc(value.Value, timeZone);
    }

    /// <summary>
    /// Converts UTC time to local time.
    /// </summary>
    /// <param name="value">Current date/time value</param>
    /// <param name="localTime">The time zone of the local machine.</param>
    /// <returns>Returns a datetime value of the local time.</returns>
    public static DateTime ToLocal(this DateTime value, string localTime)
    {
        TimeZoneInfo timeZone = TimeZoneInfo.FindSystemTimeZoneById(localTime);
        return TimeZoneInfo.ConvertTimeFromUtc(value, timeZone);
    }

    /// <summary>Gets the first week day following a date.</summary>
    /// <param name="date">The date.</param>
    /// <param name="dayOfWeek">The day of week to return.</param>
    /// <returns>The first dayOfWeek day following date, or date if it is on dayOfWeek.</returns>
    public static DateTime Next(this DateTime date, DayOfWeek dayOfWeek)
    {
        return date.AddDays((dayOfWeek < date.DayOfWeek ? 7 : 0) + dayOfWeek - date.DayOfWeek);
    }

    /// <summary>
    /// Gets a certain date for a day of week on the N'th week of a month.
    /// </summary>
    /// <param name="date">Month and year to get date for.</param>
    /// <param name="nthWeek">The week to get.</param>
    /// <param name="dayOfWeek">Day to get</param>
    /// <returns>DateTime with date requested.</returns>
    public static DateTime GetNthWeekOfMonth(DateTime date, int nthWeek, DayOfWeek dayOfWeek)
    {
        // Let's sanitize this just in case a DateTime.Now was passed - let's reset this to the first of the month.
        date = new DateTime(date.Year, date.Month, 1);
        return date.Next(dayOfWeek).AddDays((nthWeek - 1) * 7);
    }
}