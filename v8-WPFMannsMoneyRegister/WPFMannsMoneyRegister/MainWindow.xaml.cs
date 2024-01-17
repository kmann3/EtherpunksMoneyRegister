using System.Diagnostics;
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
            // Might still have to do Task.Run
            
            var settings = await AppViewModel.GetAllSettingsAsync();

            if(settings == null)
            {
                // begin guided tour
                throw new NotImplementedException();
            }

            startDatePicker.DisplayDate = DateTime.Now;
            startDatePicker.Text = DateTime.Now.ToString();
            endDatePicker.DisplayDate = DateTime.Now.AddDays(-settings.SearchDayCount);
            endDatePicker.Text = DateTime.Now.AddDays(-settings.SearchDayCount).ToString();

            // Get list of accounts and populate dropdown
            var accounts = await AppViewModel.GetAllAccountsAsync();
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
            } else
            {
                // Let's do some sanity checks in the unlikely event someone was poking around in the database and broke stuff
                if(settings.DefaultAccountId != Guid.Empty && (accounts.Count == 0))  throw new Exception("Default account assigned but no accounts found at all");
                

                // Check to see if any accounts are available
                if (accounts.Count == 1)
                {
                    // If only one exists - make it the default. This shouldn't happen since the guide should resolve this but it's possible someone went poking into the database and fudged an ID by accident
                }
                else if (accounts.Count > 1)
                {
                    // If more than one exists - prompt to see which one they would like to be the default
                }
                else
                {
                    // If zero accounts exist - prompt to see if they want to go through a guided setup.
                }                
            }
        }

        private async void TransactionListUserControl_TransactionSelected(object sender, Data.Entities.Transaction e)
        {
            await transactionItem.LoadTransaction(e);
        }

        private void LoadSelectedDates(object sender, RoutedEventArgs e)
        {
            transactionList.UpdateTransactionsFromDates(Guid.Parse(transactionAccountComboBox.SelectedValue.ToString() ?? Guid.Empty.ToString()), startDatePicker.DisplayDate, endDatePicker.DisplayDate);
        }
    }
}