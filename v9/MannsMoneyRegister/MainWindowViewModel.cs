using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace MannsMoneyRegister
{
    public class MainWindowViewModel
    {
        private void SaveConfigValue(string key, string value)
        {
            try
            {
                var configFile = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
                var settings = configFile.AppSettings.Settings;
                if (settings[key] == null)
                {
                    settings.Add(key, value);
                }
                else
                {
                    settings[key].Value = value;
                }
                configFile.Save(ConfigurationSaveMode.Modified);
                ConfigurationManager.RefreshSection(configFile.AppSettings.SectionInformation.Name);
            }
            catch (ConfigurationErrorsException ex)
            {
                Trace.WriteLine($"Error reading app.config: {ex}");
            }
        }

        public string DatabaseLocation
        {
            get => ConfigurationManager.AppSettings["DatabaseLocation"] ?? "MMR.sqlite3";
            set => SaveConfigValue("DatabaseLocation", value);
        }

        public Guid DefaultAccountId
        {
            get
            {
                if (Guid.TryParse(ConfigurationManager.AppSettings["DefaultAccountId"], out Guid id) == false)
                {
                    return Guid.Empty;
                }
                return id;
            }
            set => SaveConfigValue("DefaultAccountId", value.ToString());
        }

        public string DefaultDayCount
        {
            get => ConfigurationManager.AppSettings["DefaultDayCount"] ?? "45 days";
            set => SaveConfigValue("DefaultDayCount", value.ToString());
        }

        public DateTime DefaultSearchDayCustomStart
        {
            get
            {
                if (DateTime.TryParse(ConfigurationManager.AppSettings["DefaultSearchDayCustomStart"], out DateTime start) == false)
                {
                    return DateTime.UtcNow.AddMonths(-1);
                }
                return start;
            }
            set => SaveConfigValue("DefaultSearchDayCustomStart", value.ToString());
        }

        public DateTime DefaultSearchDayCustomEnd
        {
            get
            {
                if (DateTime.TryParse(ConfigurationManager.AppSettings["DefaultSearchDayCustomEnd"], out DateTime start) == false)
                {
                    return DateTime.UtcNow;
                }
                return start;
            }
            set => SaveConfigValue("DefaultSearchDayCustomEnd", value.ToString());
        }


    }
}
