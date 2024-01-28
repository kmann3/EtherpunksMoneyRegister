using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Windows.Controls;
using System.Windows.Data;
using System.Linq;
using WPFMannsMoneyRegister.Data;
using WPFMannsMoneyRegister.Data.Entities;
using System.Text.RegularExpressions;
using System.Windows.Input;
using WPFMannsMoneyRegister.SubWindows;

namespace WPFMannsMoneyRegister.Controls;
/// <summary>
/// Interaction logic for TransactionItemUserControl.xaml
/// </summary>
public partial class TransactionItemUserControl : UserControl
{
    private List<Account> _accounts = new();
    private TransactionItemViewModel _viewModel = new();

    public TransactionItemUserControl()
    {
        InitializeComponent();
        DataContext = _viewModel;
    }

    private async void UserControl_Loaded(object sender, System.Windows.RoutedEventArgs e)
    {
        _accounts = await ServiceModel.GetAllAccountsAsync();
        transactionAccountComboBox.ItemsSource = _accounts;
        transactionTypeComboBox.ItemsSource = Data.Entities.Base.Enums.GetTransactionTypeEnums;
        transactionFilesListView.ItemsSource = _viewModel.Files;
    }

    /// <summary>
    /// Load's a transaction.
    /// We clear the DataContext and re-pull the data from the database just in case data was left over from previous transaction as well as forces a loss of data if it's not saved.
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public async Task LoadTransaction(Guid id)
    {
        DataContext = null;
        await _viewModel.LoadAccountTransaction(id);
        DataContext = _viewModel;
        //transactionFilesListView.ItemsSource = loadedTransaction.Files;

        transactionNameTextBox.Focus();
    }

    private void AddFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        // Add a new file.
        //TransactionFile newFile = new()
        //{
        //    ContentType = "",
        //    Data = new byte[] { },
        //    Filename = "Foo.exe",
        //    Name = "Foo",
        //    Notes = "Notes here",
        //    AccountTransactionId = _viewModel.Id,
        //};

        //_viewModel.Files.Add(newFile);
        //_viewModel.PropertyFilesChanged();

        var fileWindow = new FileWindow();
        fileWindow.ShowDialog();
    }

    private void DeleteFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        if (transactionFilesListView.Items.Count == 0) return;
        List<TransactionFile> listToRemove = new();
        if(transactionFilesListView.SelectedItems.Count > 0)
        {
            // This loop is needed because you cannot remove SelectedItems in the DataContext WHILE looping through them. For some reason it throws an exception.
            foreach(var item in transactionFilesListView.SelectedItems)
            {
                listToRemove.Add(((TransactionFile)item));
            }
            // Show a message showing which item(s) will be deleted.

            // Delete them
            foreach (var itemToRemove in listToRemove)
            {
                _viewModel.Files.Remove(itemToRemove);
                _viewModel.PropertyFilesChanged();
            }
        } else
        {
            // Show a message saying nothing was selected to be deleted
        }
        
        // Remove a selected file5
    }

    private void TransactionFilesListView_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
    {
        var file = ((ListViewItem)sender).DataContext as TransactionFile;

        Trace.WriteLine($"{file.Name}");
    }

    private async void SaveFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        if (!_viewModel.IsChanged) return;

        //await ServiceModel.UpdateTransaction(_viewModel.)

        // Get the differences and show them to confirm saving.
    }
}
