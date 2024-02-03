using System.Windows;
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Windows;

/// <summary>
/// Interaction logic for FileDetails.xaml
/// </summary>
public partial class FileDetails : Window
{
    public bool isCancelled = true;
    public TransactionFile fileData = new();

    public FileDetails(TransactionFile? file)
    {
        InitializeComponent();
        if(file == null)
        {
            fileData = new();
            Title = "New File";
        } else
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
}