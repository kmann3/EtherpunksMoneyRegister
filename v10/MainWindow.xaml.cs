using MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace MannsMoneyRegister;

/// <summary>
/// Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{
    private MainWindowViewModel _viewModel = new();

    public MainWindow()
    {
        InitializeComponent();
        DataContext = _viewModel;
        _viewModel.HasChangedFromOriginal += _viewModel_HasChangedFromOriginal;
    }

    private void _viewModel_HasChangedFromOriginal(object? sender, bool e)
    {
        if (e) buttonSaveTransaction.Visibility = Visibility.Visible;
        else buttonSaveTransaction.Visibility = Visibility.Hidden;
    }

    private void AddTag()
    {
        var selectedTag = listViewUnselectedTransactionTags.SelectedItem as Tag ?? throw new Exception("Tag should not be null");
        _viewModel.AddTag(selectedTag);
    }

    private void buttonAddFile_Click(object sender, RoutedEventArgs e)
    {
        FileDetails fileWindow = new(null);
        fileWindow.Owner = this;
        fileWindow.ShowDialog();

        if (!fileWindow.IsCancelled)
        {
            var file = fileWindow.FileData;
            _viewModel.AddFile(file);
            _viewModel.PropertyFilesChanged();
        }
    }

    private void buttonAddTagToTransaction_Click(object sender, RoutedEventArgs e)
    {
        AddTag();
    }

    private void buttonDeleteFile_Click(object sender, RoutedEventArgs e)
    {
        if (listViewTransactionFiles.SelectedItem is not AccountTransactionFile file) return;

        // Check to see if they really want to delete the file
        if (MessageBox.Show($"Are you sure you want to delete: {file.Name}", "Delete file?", MessageBoxButton.YesNo) == MessageBoxResult.No) return;

        _viewModel.RemoveFile(file);
        _viewModel.PropertyFilesChanged();
    }

    private async void buttonDeleteTransaction_Click(object sender, RoutedEventArgs e)
    {
        if (((FrameworkElement)e.OriginalSource).DataContext is not AccountTransactionFile file) return;

        // Check to see if they REALLY want to delete the transaction
        if (MessageBox.Show($"Are you sure you want to delete: {file.Name}", "Delete transaction?", MessageBoxButton.YesNo) == MessageBoxResult.No) return;
        await UpdateAccountStatusLabels();
    }

    private void buttonRemoveTagFromTransaction_Click(object sender, RoutedEventArgs e)
    {
        RemoveTag();
    }

    private async void buttonSaveTransaction_Click(object sender, RoutedEventArgs e)
    {
        labelStatus.Content = "Status: saving transaction...";
        var returnData = _viewModel.SaveLoadedTransaction();
        labelStatus.Content = "Status: refreshing grid transaction...";
        await UpdateAccountStatusLabels();
        dataGridTransactions.Items.Refresh();
        labelStatus.Content = "Status: Idle";
    }

    private async void datagridButtonClearTransaction_Click(object sender, RoutedEventArgs e)
    {
        labelStatus.Content = "Status: Marking transaction as cleared...";
        AccountTransaction selectedTransaction = ((FrameworkElement)sender).DataContext as AccountTransaction ?? throw new Exception("Unknown type of grid row");
        selectedTransaction = await _viewModel.MarkTransactionAsClearedAsync(selectedTransaction);
        _viewModel.LoadTransaction(selectedTransaction);
        dataGridTransactions.Items.Refresh();
        await UpdateAccountStatusLabels();
        labelStatus.Content = "Status: Idle";
    }

    private async void datagridButtonPendingTransaction_Click(object sender, RoutedEventArgs e)
    {
        labelStatus.Content = "Status: Marking transaction as pending...";
        AccountTransaction selectedTransaction = ((FrameworkElement)sender).DataContext as AccountTransaction ?? throw new Exception("Unknown type of grid row");
        selectedTransaction = await _viewModel.MarkTransactionAsPendingAsync(selectedTransaction);
        _viewModel.LoadTransaction(selectedTransaction);
        dataGridTransactions.Items.Refresh();
        await UpdateAccountStatusLabels();
        labelStatus.Content = "Status: Idle";
    }

    private async void dataGridTransactions_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (dataGridTransactions.SelectedItem is not AccountTransaction) return;
        labelStatus.Content = "Status: loading transaction...";
        var currentTransaction = dataGridTransactions.SelectedItem as AccountTransaction ?? throw new Exception("Unknown error in method dataGridTransactions_SelectionChanged.");
        _viewModel.LoadTransaction(currentTransaction);
        labelStatus.Content = "Status: Idle";
    }

    private void listViewSelectedTransactionTags_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {
        RemoveTag();
    }

    private void listViewTransactionFiles_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {
        if (((FrameworkElement)e.OriginalSource).DataContext is not AccountTransactionFile file) return;

        FileDetails fileWindow = new(file);
        fileWindow.Owner = this;
        fileWindow.ShowDialog();

        if (!fileWindow.IsCancelled)
        {
            if (file == null) throw new NullReferenceException("File cannot be null. This should not happen");
            _viewModel.ModifyFile(fileWindow.FileData);
        }
    }

    private void listViewUnselectedTransactionTags_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {
        AddTag();
    }

    private void RemoveTag()
    {
        var selectedTag = listViewSelectedTransactionTags.SelectedItem as Tag ?? throw new Exception("Tag should not be null");
        _viewModel.RemoveTag(selectedTag);
    }

    private void ribbonButton_Dashboard_CustomRange_Click(object sender, RoutedEventArgs e)
    {
        ribbonPopup_Dashboard_CustomRangeStart.IsOpen = !ribbonPopup_Dashboard_CustomRangeStart.IsOpen;
    }

    private void ribbonButton_Dashboard_NewAccount_Click(object sender, RoutedEventArgs e)
    {
        throw new NotImplementedException();
    }

    private void ribbonButton_Dashboard_NewTransaction_Click(object sender, RoutedEventArgs e)
    {
        _viewModel.CreateNewTransaction();
        textBoxTransactionName.Focus();
    }

    private async void ribbonButton_Dashboard_RecalculateAccount_Click(object sender, RoutedEventArgs e)
    {
        await _viewModel.RecalculateAccountAsync();
        await _viewModel.LoadAccount(null);
        dataGridTransactions.ItemsSource = _viewModel.Transactions;
        UpdateAccountStatusLabels();
    }

    private void ribbonButton_Dashboard_ReserveTransaction_Click(object sender, RoutedEventArgs e)
    {
        throw new NotImplementedException();
        UpdateAccountStatusLabels();
    }

    private async void ribbonComboBox_Dashboard_AccountSelection_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {
        labelStatus.Content = "Status: loading transactions...";
        await _viewModel.LoadAccount(((Account)e.NewValue).Id);
        dataGridTransactions.ItemsSource = _viewModel.Transactions;

        //throw new NotImplementedException("Need to implement clearing of any loaded transactions");
        await UpdateAccountStatusLabels();
        labelStatus.Content = "Status: Idle";
    }

    private async void ribbonComboBox_Dashboard_DayCount_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {
        labelStatus.Content = "Status: loading transactions...";

        switch (ribbonComboBox_Dashboard_SearchDayCount.SelectedValue)
        {
            case "30 Days":
                _viewModel.TransactionStartDate = DateTime.UtcNow.AddDays(-30);
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Hidden;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Hidden;
                break;

            case "45 Days":
                _viewModel.TransactionStartDate = DateTime.UtcNow.AddDays(-45);
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Hidden;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Hidden;
                break;

            case "60 Days":
                _viewModel.TransactionStartDate = DateTime.UtcNow.AddDays(-60);
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Hidden;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Hidden;
                break;

            case "90 Days":
                _viewModel.TransactionStartDate = DateTime.UtcNow.AddDays(-365);
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Hidden;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Hidden;
                break;

            case "Custom":
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Visible;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Visible;
                break;

            default:
                throw new Exception("Unknown selection");
        }

        await _viewModel.LoadAccount(null);
        dataGridTransactions.ItemsSource = _viewModel.Transactions;
        labelStatus.Content = "Status: Idle";
    }

    private async Task UpdateAccountStatusLabels()
    {
        await _viewModel.LoadAccount(null);
        labelBalance.Content = $"Balance: {_viewModel.LoadedAccount.CurrentBalance:C}";
        labelOutstanding.Content = _viewModel.LoadedAccount.OutstandingSummary;
    }

    private async void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
    {
        await _viewModel.CloseDatabaseAsync();
    }

    /// <summary>
    /// Load default settings
    /// Load database transactions, accounts, etc - get the window ready to be used.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private async void Window_Loaded(object sender, RoutedEventArgs e)
    {
        await _viewModel.Initialize();

        ribbonComboBox_Dashboard_AccountSelectionList.ItemsSource = _viewModel.AccountList;
        ribbonComboBox_Dashboard_AccountSelectionList.DisplayMemberPath = "Name";
        ribbonComboBox_Dashboard_AccountSelection.SelectedValuePath = "Id";
        ribbonComboBox_Dashboard_AccountSelection.SelectedValue = _viewModel.LoadedAccount.Id;

        switch (_viewModel.DefaultSearchDayCount)
        {
            case "Custom":
                ribbonComboBox_Dashboard_SearchDayCount.SelectedValue = "Custom";
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Visibility = Visibility.Visible;
                ribbonTextBox_Dashboard_CustomRangeDisplayStart.Text = _viewModel.TransactionStartDate.ToShortDateString();
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Visibility = Visibility.Visible;
                ribbonTextBox_Dashboard_CustomRangeDisplayEnd.Text = _viewModel.TransactionEndDate.ToShortDateString();
                // Show the date range textbox
                break;

            default:
                ribbonComboBox_Dashboard_SearchDayCount.SelectedValue = _viewModel.DefaultSearchDayCount;
                break;
        }

        await _viewModel.LoadAccount(null);
        dataGridTransactions.ItemsSource = _viewModel.Transactions;

        comboBoxAccount.DisplayMemberPath = "Name";
        comboBoxAccount.SelectedValuePath = "Id";
        comboBoxAccount.ItemsSource = _viewModel.AccountList;
        comboBoxAccount.SelectedValue = _viewModel.LoadedAccount.Id;

        comboBoxTransactionType.ItemsSource = Data.Entities.Base.Enums.GetTransactionTypeEnums;

        await UpdateAccountStatusLabels();

        textBoxTransactionName.Focus();
    }

    private void datePickerPendingDate_CalendarOpened(object sender, RoutedEventArgs e)
    {
        if(datePickerPendingDate.SelectedDate == null) datePickerPendingDate.SelectedDate = DateTime.Now;
    }

    private void datePickerClearedDate_CalendarOpened(object sender, RoutedEventArgs e)
    {
        if (datePickerClearedDate.SelectedDate == null) datePickerClearedDate.SelectedDate = DateTime.Now;
    }
}