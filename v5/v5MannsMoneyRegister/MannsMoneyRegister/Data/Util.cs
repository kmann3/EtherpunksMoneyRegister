namespace MannsMoneyRegister.Data
{
    public static class Util
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
    }
}
