using MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Ribbon;
using System.Windows.Data;
using System.Windows.Input;

namespace MannsMoneyRegister;

/// <summary>
/// Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{
    private DateTime _transactionStartDate = DateTime.UtcNow.AddDays(-45);
    private DateTime _transactionEndDate = DateTime.UtcNow;
    private Account _loadedAccount = new();
    private MainWindowViewModel _viewModel = new();
    public MainWindow()
    {
        InitializeComponent();
        DataContext = _viewModel;
        AppService.Initialize();
    }

    /// <summary>
    /// Load default settings
    /// Load database transactions, accounts, etc - get the window ready to be used.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private async void Window_Loaded(object sender, RoutedEventArgs e)
    {
        await AppService.LoadDatabaseAsync(null);

        _loadedAccount = AppService.Account;

        ribbonComboBox_Dashboard_AccountSelectionList.ItemsSource = AppService.AccountList;
        ribbonComboBox_Dashboard_AccountSelectionList.DisplayMemberPath = "Name";
        ribbonComboBox_Dashboard_AccountSelection.SelectedValuePath = "Id";
        ribbonComboBox_Dashboard_AccountSelection.SelectedValue = _loadedAccount.Id;

        switch (AppService.DefaultSearchDayCount)
        {
            case "Custom":
                ribbonComboBox_Dashboard_SearchDayCount.SelectedValue = "Custom";
                _transactionStartDate = AppService.DefaultSearchDayCustomStart;
                _transactionEndDate = AppService.DefaultSearchDayCustomEnd;
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Visible;
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Text = _transactionStartDate.ToShortDateString();
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Visible;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Text = _transactionEndDate.ToShortDateString();
                // Show the date range textbox
                break;
            default:
                if (AppService.DefaultSearchDayCount is "30 Days" or "45 Days" or "60 Days" or "90 Days")
                {
                    ribbonComboBox_Dashboard_SearchDayCount.SelectedValue = AppService.DefaultSearchDayCount;
                }
                else
                {
                    Trace.WriteLine($"Error parsing app.config's key 'DefaultSearchDayCount'. The value we got was: {AppService.DefaultSearchDayCount}. We are going to re-assign to 45 Days.");
                    AppService.DefaultSearchDayCount = "45 Days";
                    ribbonComboBox_Dashboard_SearchDayCount.SelectedValue = AppService.DefaultSearchDayCount;
                }
                break;
        }
        
        _viewModel.Transactions = await AppService.GetAccountTransactionsByDateRangeAsync(_loadedAccount.Id, _transactionStartDate, _transactionEndDate);
        dataGridTransactions.ItemsSource = _viewModel.Transactions;

        comboBoxAccount.DisplayMemberPath = "Name";
        comboBoxAccount.SelectedValuePath = "Id";
        comboBoxAccount.ItemsSource = AppService.AccountList;
        comboBoxAccount.SelectedValue = AppService.Account.Id;

        comboBoxTransactionType.ItemsSource = Data.Entities.Base.Enums.GetTransactionTypeEnums;

        labelOutstanding.Content = AppService.Account.OutstandingSummary;
    }

    private async void ribbonComboBox_Dashboard_AccountSelection_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {
        labelStatus.Content = "Status: loading transactions...";
        _loadedAccount = await AppService.LoadAccountAsync(((Account)e.NewValue).Id);
        _viewModel.Transactions = await AppService.GetAccountTransactionsByDateRangeAsync(_loadedAccount.Id, _transactionStartDate, _transactionEndDate);
        dataGridTransactions.ItemsSource = _viewModel.Transactions;

        //throw new NotImplementedException("Need to implement clearing of any loaded transactions");
        // Update account info at status bar
        labelOutstanding.Content = AppService.Account.OutstandingSummary;
        labelStatus.Content = "Status: Idle";
    }

    private async void ribbonComboBox_Dashboard_DayCount_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {
        labelStatus.Content = "Status: loading transactions...";

        switch (ribbonComboBox_Dashboard_SearchDayCount.SelectedValue)
        {
            case "30 Days":
                _transactionStartDate = DateTime.UtcNow.AddDays(-30);
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Hidden;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Hidden;

                break;
            case "45 Days":
                _transactionStartDate = DateTime.UtcNow.AddDays(-45);
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Hidden;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Hidden;

                break;
            case "60 Days":
                _transactionStartDate = DateTime.UtcNow.AddDays(-60);
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Hidden;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Hidden;

                break;
            case "90 Days":
                _transactionStartDate = DateTime.UtcNow.AddDays(-365);
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Hidden;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Hidden;

                break;
            case "Custom":
                // Popup the box asking for a date range
                //throw new NotImplementedException();
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Visible;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Visible;


                break;
            default:
                throw new Exception("Unknown selection");
        }

        _viewModel.Transactions = await AppService.GetAccountTransactionsByDateRangeAsync(_loadedAccount.Id, _transactionStartDate, _transactionEndDate);
        dataGridTransactions.ItemsSource = _viewModel.Transactions;
        labelStatus.Content = "Status: Idle";
    }

    private void ribbonButton_Dashboard_CustomRange_Click(object sender, RoutedEventArgs e)
    {
        ribbonPopup_Dashboard_CustomRangeStart.IsOpen = !ribbonPopup_Dashboard_CustomRangeStart.IsOpen;
    }

    private void ribbonButton_Dashboard_NewTransaction_Click(object sender, RoutedEventArgs e)
    {
        labelStatus.Content = "Status: creating new transaction...";
        _viewModel.CreateNewTransaction(_loadedAccount.Id);
        labelStatus.Content = "Status: Idle";
        textBoxTransactionName.Focus();
    }

    private void ribbonButton_Dashboard_NewAccount_Click(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonButton_Dashboard_ReserveTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private async void dataGridTransactions_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (dataGridTransactions.SelectedItem is not AccountTransaction) return;
        labelStatus.Content = "Status: loading transaction...";
        var currentTransaction = dataGridTransactions.SelectedItem as AccountTransaction ?? throw new Exception("Unknown error in method dataGridTransactions_SelectionChanged.");
        await _viewModel.LoadTransaction(currentTransaction);
        labelStatus.Content = "Status: Idle";
    }

    private void buttonSaveTransaction_Click(object sender, RoutedEventArgs e)
    {
        // SAVE INFORMATION
        labelStatus.Content = "Status: saving transaction...";
        var returnData = _viewModel.SaveLoadedTransaction();

        labelStatus.Content = "Status: refreshing grid transaction...";
        labelOutstanding.Content = AppService.Account.OutstandingSummary;
        dataGridTransactions.Items.Refresh();
        labelStatus.Content = "Status: Idle";

    }

    private void AddTag()
    {
        var selectedTag = listViewUnselectedTransactionTags.SelectedItem as Tag ?? throw new Exception("Tag should not be null");
        _viewModel.AddTag(selectedTag);
    }

    private void RemoveTag()
    {
        var selectedTag = listViewSelectedTransactionTags.SelectedItem as Tag ?? throw new Exception("Tag should not be null");
        _viewModel.RemoveTag(selectedTag);
    }

    private void listViewUnselectedTransactionTags_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {
        AddTag();
    }

    private void listViewSelectedTransactionTags_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {
        RemoveTag();
    }

    private void buttonRemoveTagFromTransaction_Click(object sender, RoutedEventArgs e)
    {
        RemoveTag();
    }

    private void buttonAddTagToTransaction_Click(object sender, RoutedEventArgs e)
    {
        AddTag();
    }

    private void listViewItem_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {
        // open file dialog
    }

    private void buttonDeleteTransaction_Click(object sender, RoutedEventArgs e)
    {
        // Check to see if they REALLY want to delete the transaction
    }

    private void buttonDeleteFile_Click(object sender, RoutedEventArgs e)
    {
        // Check to see if they really want to delete the file
    }

    private void buttonAddFile_Click(object sender, RoutedEventArgs e)
    {
        // Show popup dialog for adding a file.
    }

    private async void datagridButtonClearTransaction_Click(object sender, RoutedEventArgs e)
    {
        labelStatus.Content = "Status: Marking transaction as cleared...";
        AccountTransaction selectedTransaction = ((FrameworkElement)sender).DataContext as AccountTransaction ?? throw new Exception("Unknown type of grid row");
        selectedTransaction = await AppService.MarkTransactionAsClearedAsync(selectedTransaction);
        dataGridTransactions.Items.Refresh();
        labelStatus.Content = "Status: Idle";
    }

    private async void datagridButtonPendingTransaction_Click(object sender, RoutedEventArgs e)
    {
        labelStatus.Content = "Status: Marking transaction as pending...";
        AccountTransaction selectedTransaction = ((FrameworkElement)sender).DataContext as AccountTransaction ?? throw new Exception("Unknown type of grid row");
        selectedTransaction = await AppService.MarkTransactionAsPendingAsync(selectedTransaction);
        await _viewModel.LoadTransaction(selectedTransaction);
        dataGridTransactions.Items.Refresh();
        labelStatus.Content = "Status: Idle";
    }

    private async void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
    {
        await AppService.CloseFileAsync();
    }
}