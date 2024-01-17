using WPFMannsMoneyRegister.Data.Entities;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.ComponentModel;
using Humanizer;
using WPFMannsMoneyRegister.Data;

namespace WPFMannsMoneyRegister;
/// <summary>
/// Interaction logic for TransactionListUserControl.xaml
/// </summary>
public partial class TransactionListUserControl : UserControl
{
    private List<Transaction> _transactions = [];

    public event EventHandler<Transaction> TransactionSelected;

    public TransactionListUserControl()
    {
        InitializeComponent();
    }

    public async void UpdateTransactionsFromDates(Guid accountId, DateTime startDate, DateTime endDate)
    {
        _transactions = await AppViewModel.GetAllTransactionsForAccountAsync(accountId, startDate, endDate);
        DataGridTransactions.ItemsSource = _transactions;

        IEditableCollectionView cv = (IEditableCollectionView)DataGridTransactions.Items;
        cv.NewItemPlaceholderPosition = NewItemPlaceholderPosition.AtBeginning;
    }

    private async void MarkPending(object sender, RoutedEventArgs e)
    {
        var transData = DataGridTransactions.SelectedItem as Transaction ?? throw new Exception("Transaction data is null.");

        // This is where we update the data and re-pull it
        transData.TransactionPendingUTC = DateTime.UtcNow;
        await AppViewModel.UpdateTransaction(transData);
        DataGridTransactions.Items.Refresh();
    }
    private async void MarkCleared(object sender, RoutedEventArgs e)
    {
        var transData = DataGridTransactions.SelectedItem as Transaction ?? throw new Exception("Transaction data is null.");
        transData.TransactionClearedUTC = DateTime.UtcNow;
        await AppViewModel.UpdateTransaction(transData);
        DataGridTransactions.Items.Refresh();
    }

    private void DataGridTransactions_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if(DataGridTransactions.SelectedItem is Transaction && TransactionSelected != null)
        {
            TransactionSelected(this, DataGridTransactions.SelectedItem as Transaction ?? throw new Exception("Transaction data is null."));
        }
    }
}
