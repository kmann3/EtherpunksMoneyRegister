using MannsMoneyRegister.Data.Entities;
using System.Configuration;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Ribbon;
using System.Windows.Input;

namespace MannsMoneyRegister;

/// <summary>
/// Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        
    }

    /// <summary>
    /// Load default settings
    /// Load datadase transactions, accounts, etc - get the window ready to be used.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private async void Window_Loaded(object sender, RoutedEventArgs e)
    {
        await MainWindowViewModel.LoadDatabaseAsync(MainWindowViewModel.DatabaseLocation);

        Guid defaultAccountId = MainWindowViewModel.DefaultAccountId;
        ribbonComboBox_Dashboard_AccountSelectionList.ItemsSource = MainWindowViewModel.AccountList;
        ribbonComboBox_Dashboard_AccountSelectionList.DisplayMemberPath = "Name";
        ribbonComboBox_Dashboard_AccountSelection.SelectedValuePath = "Id";
        ribbonComboBox_Dashboard_AccountSelection.SelectedValue = defaultAccountId;

        switch (MainWindowViewModel.DefaultSearchDayCount)
        {
            case "Custom":
                ribbonComboBox_Dashboard_SearchDayCount.SelectedValue = "Custom";
                // Assign start and end dates
                break;
            default:
                if (MainWindowViewModel.DefaultSearchDayCount is "30 Days" or "45 Days" or "60 Days" or "90 Days")
                {
                    ribbonComboBox_Dashboard_SearchDayCount.SelectedValue = MainWindowViewModel.DefaultSearchDayCount;
                }
                else
                {
                    Trace.WriteLine($"Error parsing app.config's key 'DefaultSearchDayCount'. The value we got was: {MainWindowViewModel.DefaultSearchDayCount}. We are going to re-assign to 45 Days.");
                    MainWindowViewModel.DefaultSearchDayCount = "45 Days";
                    ribbonComboBox_Dashboard_SearchDayCount.SelectedValue = MainWindowViewModel.DefaultSearchDayCount;
                }
                break;
        }

    }

    private void ribbonComboBox_Dashboard_AccountSelection_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {

    }

    private void ribbonComboBox_Dashboard_DayCount_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {

    }

    private void ribbonButton_Dashboard_CustomRange_Click(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonButton_Dashboard_NewTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonButton_Dashboard_NewAccount_Click(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonCheckBox_Dashboard_Autoload_Checked(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonButton_Dashboard_ReserveTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void dataGridTransactions_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {

    }

    private void buttonSaveTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void listViewUnselectedTransactionTags_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {

    }

    private void listViewSelectedTransactionTags_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {

    }

    private void buttonRemoveTagFromTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void buttonAddTagToTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void listViewItem_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {

    }

    private void buttonDeleteTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void buttonDeleteFile_Click(object sender, RoutedEventArgs e)
    {

    }

    private void buttonAddFile_Click(object sender, RoutedEventArgs e)
    {

    }
}