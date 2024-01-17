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

            startDatePicker.DisplayDate = DateTime.Now;
            startDatePicker.Text = DateTime.Now.ToString();
            endDatePicker.DisplayDate = DateTime.Now.AddDays(-settings.SearchDayCount);
            endDatePicker.Text = DateTime.Now.AddDays(-settings.SearchDayCount).ToString();

            // Get list of accounts and populate dropdown
            if (settings.DefaultAccountId != Guid.Empty)
            {
                var accounts = await AppViewModel.GetAllAccountsAsync();
                accounts = accounts.OrderBy(x => x.Name).ToList();
                transactionAccountComboBox.ItemsSource = accounts;
                transactionAccountComboBox.DisplayMemberPath = "Name";
                transactionAccountComboBox.SelectedValuePath = "Id";
                transactionAccountComboBox.SelectedValue = settings.DefaultAccountId;

                // Get a list of transactions for that account
                LoadSelectedDates(sender, e);
            } else
            {
                // Check to see if any accounts are available

                // If only one exists - make it the default. This shouldn't happen since the guide should resolve this but whatever.

                // If more than one exists

                // If zero accounts exist
                throw new NotImplementedException("No accounts exist or a default is not selected");
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