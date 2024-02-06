using MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore;
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
    public  class MainWindowViewModel
    {
        private static ApplicationDbContext _context = new();
        private static void SaveConfigValue(string key, string value)
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

        private static List<Account> _accountList = new();
        public static List<Account> AccountList
        {
            get
            {
                _accountList = [.. _context.Accounts.OrderBy(x => x.Name)];
                return _accountList;
            }
        }

        public static string DatabaseLocation
        {
            get => ConfigurationManager.AppSettings["DatabaseLocation"] ?? "MMR.sqlite3";
            set => SaveConfigValue("DatabaseLocation", value);
        }

        public static Guid DefaultAccountId
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

        public static string DefaultSearchDayCount
        {
            get => ConfigurationManager.AppSettings["DefaultSearchDayCount"] ?? "45 Days";
            set => SaveConfigValue("DefaultSearchDayCount", value.ToString());
        }

        public static DateTime DefaultSearchDayCustomStart
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

        public static DateTime DefaultSearchDayCustomEnd
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

        public static async Task<List<AccountTransaction>> GetAllAccountTransactionsAsync(Guid accountId, DateTime startDate, DateTime endDate)
        {
            List<AccountTransaction> _transactions = await _context.AccountTransactions
            .Include(x => x.Categories)
            .Where(x => x.AccountId == accountId)
            .Where(x => x.CreatedOnUTC >= endDate)
            .Where(x => x.CreatedOnUTC <= startDate)
            .ToListAsync();

            // Make sure that pending and uncleared items are ALWAYS added regardless of date, so we don't accidentally leave something sitting out and it's date goes way past a normal search
            // For example, we don't want an uncashed check that's 60 days old forgotten, not cleared, and now shown.
            List<AccountTransaction> pendingAndClearedTransactions = await _context.AccountTransactions
                .Include(x => x.Categories)
                .Where(x => x.AccountId == accountId)
                .Where(x => x.TransactionPendingUTC == null || x.TransactionClearedUTC == null)
                .ToListAsync();

            // Merge the two lists
            List<AccountTransaction> returnList = [.. _transactions.Concat(pendingAndClearedTransactions).Distinct()
            .OrderByDescending(x => x.TransactionClearedUTC == null && x.TransactionPendingUTC != null)
            .ThenByDescending(x => x.TransactionPendingUTC == null && x.TransactionClearedUTC == null)
            .ThenByDescending(x => x.CreatedOnUTC)];

            return returnList;
        }

        public static async Task LoadDatabaseAsync(string fileName)
        {
            ApplicationDbContext.DatabaseLocation = fileName;
            await _context.DisposeAsync(); // I don't know if I need to do this
            _context = new();
        }
    }
}
