using MannsMoneyRegister.Data.Entities;
using System.Windows;

namespace MannsMoneyRegister;

/// <summary>
/// Interaction logic for FileDetails.xaml
/// </summary>
public partial class FileDetails : Window
{
    public bool isCancelled = true;
    public AccountTransactionFile fileData = new();

    public FileDetails(AccountTransactionFile? file)
    {
        InitializeComponent();
        if (file == null)
        {
            fileData = new();
            Title = "New File";
        }
        else
        {
            Title = $"File details: {fileData.Name}";
        }

        DataContext = fileData;
    }

    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        Close();
    }

    private void Save_Click(object sender, RoutedEventArgs e)
    {
        isCancelled = false;
        Close();
    }

    private void DownloadFile_Click(object sender, RoutedEventArgs e)
    {

    }

    private void AttachFile_Click(object sender, RoutedEventArgs e)
    {

    }
}