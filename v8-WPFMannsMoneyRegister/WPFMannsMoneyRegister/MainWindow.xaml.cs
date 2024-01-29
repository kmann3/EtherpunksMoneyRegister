using Microsoft.EntityFrameworkCore.Diagnostics;
using System.Configuration;
using System.Diagnostics;
using System.Reflection;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using WPFMannsMoneyRegister.Data;


namespace WPFMannsMoneyRegister
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();  
            
        }

        public async void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            await LoadData(sender, e);
        }

        private async void TransactionListUserControl_TransactionSelected(object sender, Guid e)
        {
            await transactionItem.LoadTransaction(e);
        }

        private void LoadSelectedDates(object sender, RoutedEventArgs e)
        {
            transactionList.UpdateTransactionsFromDates(Guid.Parse(transactionAccountComboBox.SelectedValue.ToString() ?? Guid.Empty.ToString()), startDatePicker.DisplayDate, endDatePicker.DisplayDate);
        }

        private void LoadDatabaseButton_Click(object sender, RoutedEventArgs e)
        {
            //Configuration oConfig = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
            //oConfig.AppSettings.Settings["databaseLocation"].Value = $"d:\\src\\wpfMMR.sqlite32";
            //oConfig.Save(ConfigurationSaveMode.Full);
            //ConfigurationManager.RefreshSection("appSettings");
            //string db = ConfigurationManager.AppSettings["databaseLocation"] ?? "";

            //Trace.WriteLine(db);
            throw new NotImplementedException();
        }

        private async Task LoadData(object sender, RoutedEventArgs e)
        {
            // See if we have a specified location. If not, then fall back to the default file.
            string db = ConfigurationManager.AppSettings["databaseLocation"] ?? "";
            if(String.IsNullOrEmpty(db))
            {
                db = "";
            } else if (!System.IO.File.Exists(db))
            {
                // File doesn't exist
                throw new System.IO.FileNotFoundException(db);
            }

            AppDbService.LoadDatabase(db);
            
            // Might still have to do Task.Run

            var settings = await AppDbService.GetAllSettingsAsync();

            if (settings == null)
            {
                // begin guided tour
                throw new NotImplementedException();
            }

            startDatePicker.DisplayDate = DateTime.Now;
            startDatePicker.Text = DateTime.Now.ToString();
            endDatePicker.DisplayDate = DateTime.Now.AddDays(-settings.SearchDayCount);
            endDatePicker.Text = DateTime.Now.AddDays(-settings.SearchDayCount).ToString();

            // Get list of accounts and populate dropdown
            var accounts = await AppDbService.GetAllAccountsAsync();
            if (settings.DefaultAccountId != Guid.Empty && accounts.Count > 0)
            {
                // Let's do some sanity checks in the unlikely event someone was poking around in the database and broke stuff
                if (settings.DefaultAccountId != Guid.Empty && (accounts.Where(x => x.Id == settings.DefaultAccountId).Count() == 0)) throw new Exception("Default account not found in database. Possible corruption?");
                if (settings.DefaultAccountId != Guid.Empty && (accounts.Where(x => x.Id == settings.DefaultAccountId).Count() > 1)) throw new Exception("Default account returned more than one account. Possible corruption?");

                accounts = accounts.OrderBy(x => x.Name).ToList();
                transactionAccountComboBox.ItemsSource = accounts;
                transactionAccountComboBox.DisplayMemberPath = "Name";
                transactionAccountComboBox.SelectedValuePath = "Id";
                transactionAccountComboBox.SelectedValue = settings.DefaultAccountId;

                // Get a list of transactions for that account
                LoadSelectedDates(sender, e);
            }
            else
            {
                // Let's do some sanity checks in the unlikely event someone was poking around in the database and broke stuff
                if (settings.DefaultAccountId != Guid.Empty && (accounts.Count == 0)) throw new Exception("Default account assigned but no accounts found at all");


                // Check to see if any accounts are available
                if (accounts.Count == 1)
                {
                    // If only one exists - make it the default. This shouldn't happen since the guide should resolve this but it's possible someone went poking into the database and fudged an ID by accident
                    throw new NotImplementedException();
                }
                else if (accounts.Count > 1)
                {
                    // If more than one exists - prompt to see which one they would like to be the default
                    throw new NotImplementedException();
                }
                else
                {
                    // If zero accounts exist - prompt to see if they want to go through a guided setup.
                    throw new NotImplementedException();
                }
            }
        }

        private async void NewTransactionButton_Click(object sender, RoutedEventArgs e)
        {
            await transactionItem.LoadTransaction(null);
        }
    }
}