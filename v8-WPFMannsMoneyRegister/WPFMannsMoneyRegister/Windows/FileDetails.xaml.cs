using System.Windows;
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Windows;

/// <summary>
/// Interaction logic for FileDetails.xaml
/// </summary>
public partial class FileDetails : Window
{
    public bool isCancelled = false;
    public TransactionFile fileData = new();
    public string title = "New File";
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

    public FileDetails(string title)
    {
        InitializeComponent();
        Title = title;
        DataContext = fileData;
    }

    
    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        Close();
        isCancelled = true;
    }

    private void Save_Click(object sender, RoutedEventArgs e)
    {

    }
}