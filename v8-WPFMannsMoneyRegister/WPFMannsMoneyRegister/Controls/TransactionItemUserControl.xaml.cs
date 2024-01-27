using System.ComponentModel;
using System.Diagnostics;
using System.Windows.Controls;
using System.Windows.Data;
using WPFMannsMoneyRegister.Data;
using WPFMannsMoneyRegister.Data.Entities;

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
        ((AccountTransaction)DataContext).Name = "FOO2";

        Trace.WriteLine($"{loadedTransaction.Name} and {(this.DataContext as AccountTransaction).Name} |  old: {previousVersion.Name}");
    }

    private void DeleteFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        // Remove a selected file5
    }

    private void TransactionFilesListView_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
    {
        var file = ((ListViewItem)sender).DataContext as TransactionFile;

        Trace.WriteLine($"{file.Name}");
    }
}
