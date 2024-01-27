﻿using WPFMannsMoneyRegister.Data.Entities;
using System.Windows;
using System.Windows.Controls;
using System.ComponentModel;
using WPFMannsMoneyRegister.Data;

namespace WPFMannsMoneyRegister;
/// <summary>
/// Interaction logic for TransactionListUserControl.xaml
/// </summary>
public partial class TransactionListUserControl : UserControl
{
    private List<AccountTransaction> _transactions = [];

    public event EventHandler<Guid> TransactionSelected;

    public TransactionListUserControl()
    {
        InitializeComponent();
    }

    public async void UpdateTransactionsFromDates(Guid accountId, DateTime startDate, DateTime endDate)
    {
        _transactions = await ServiceModel.GetAllTransactionsForAccountAsync(accountId, startDate, endDate);
        DataGridTransactions.ItemsSource = _transactions;

        IEditableCollectionView cv = (IEditableCollectionView)DataGridTransactions.Items;
        cv.NewItemPlaceholderPosition = NewItemPlaceholderPosition.AtBeginning;
    }

    private async void MarkPending(object sender, RoutedEventArgs e)
    {
        var transData = DataGridTransactions.SelectedItem as AccountTransaction ?? throw new Exception("Transaction data is null.");

        // This is where we update the data and re-pull it
        transData.TransactionPendingUTC = DateTime.UtcNow;
        await ServiceModel.UpdateTransaction(transData);
        DataGridTransactions.Items.Refresh();
    }
    private async void MarkCleared(object sender, RoutedEventArgs e)
    {
        var transData = DataGridTransactions.SelectedItem as AccountTransaction ?? throw new Exception("Transaction data is null.");

        transData.TransactionClearedUTC = DateTime.UtcNow;
        await ServiceModel.UpdateTransaction(transData);
        DataGridTransactions.Items.Refresh();
    }

    private void DataGridTransactions_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if(DataGridTransactions.SelectedItem is AccountTransaction && TransactionSelected != null)
        {
            TransactionSelected(this, (DataGridTransactions.SelectedItem as AccountTransaction ?? throw new Exception("Transaction data is null.")).Id);
        }
    }
}
