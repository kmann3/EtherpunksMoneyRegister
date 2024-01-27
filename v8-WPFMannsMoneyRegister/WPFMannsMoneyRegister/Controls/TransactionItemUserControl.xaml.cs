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

namespace WPFMannsMoneyRegister.Controls;
/// <summary>
/// Interaction logic for TransactionItemUserControl.xaml
/// </summary>
public partial class TransactionItemUserControl : UserControl
{
    private List<Account> _accounts = new();
    private AccountTransaction previousVersion = new();
    private AccountTransaction loadedTransaction = new();

    public TransactionItemUserControl()
    {
        InitializeComponent();
        DataContext = loadedTransaction;
    }

    private async void UserControl_Loaded(object sender, System.Windows.RoutedEventArgs e)
    {
        _accounts = await ServiceModel.GetAllAccountsAsync();
        transactionAccountComboBox.ItemsSource = _accounts;
        transactionTypeComboBox.ItemsSource = Data.Entities.Base.Enums.GetTransactionTypeEnums;
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
        loadedTransaction = await ServiceModel.GetTransactionAsync(id);
        previousVersion = loadedTransaction.DeepClone();
        DataContext = loadedTransaction;
        transactionFilesListView.ItemsSource = loadedTransaction.Files;

        transactionNameTextBox.Focus();
    }

    private void AddFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        Trace.WriteLine($"{loadedTransaction.Name} and {(this.DataContext as AccountTransaction).Name} |  old: {previousVersion.Name}");
        // Add a new file.
        TransactionFile newFile = new()
        {
            ContentType = "",
            Data = new byte[] { },
            Filename = "Foo.exe",
            Name = "Foo",
            Notes = "Notes here",
            AccountTransactionId = loadedTransaction.Id,
        };

        loadedTransaction.Files.Add(newFile);

        loadedTransaction.Name = "FOOOOOO";

        Trace.WriteLine($"{loadedTransaction.Name} and {transactionNameTextBox.Text} |  old: {previousVersion.Name}");
    }

    private void DeleteFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        if (transactionFilesListView.Items.Count == 0) return;
        List<TransactionFile> listToRemove = new();
        if(transactionFilesListView.SelectedItems.Count > 0)
        {
            foreach(var item in transactionFilesListView.SelectedItems)
            {
                // Show a message showing which item(s) will be deleted.
                listToRemove.Add(((TransactionFile)item));
            }

            foreach(var itemToRemove in listToRemove)
            {
                loadedTransaction.Files.Remove(itemToRemove);
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

    private void SaveFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        if(loadedTransaction.DeepEquals(previousVersion)) return;

        // Get the differences and show them to confirm saving.
    }
}
