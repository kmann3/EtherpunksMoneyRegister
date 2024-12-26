using MannsMoneyRegister.Data.Entities;
using MannsMoneyRegister.Windows;
using Microsoft.Win32;
using System.IO;
using System.Windows;

namespace MannsMoneyRegister;

/// <summary>
/// Interaction logic for FileDetails.xaml
/// </summary>
public partial class FileDetails : Window
{
    public bool IsCancelled = true;
    private readonly FileDetailsViewModel _viewModel = new();
    public AccountTransactionFile FileData = new();

    public FileDetails(AccountTransactionFile? file)
    {
        InitializeComponent();

        _viewModel.LoadData(file);

        if (file == null)
        {
            FileData = new();
            Title = "New File";
            fileSizeLabel.Visibility = Visibility.Hidden;
            buttonDownload.Visibility = Visibility.Hidden;
        }
        else
        {
            Title = $"File details: {_viewModel.Filename}";
        }

        DataContext = _viewModel;
    }

    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        if(_viewModel.IsChanged)
        {
            if (MessageBox.Show("Changes have been made. Close anyways?", "", MessageBoxButton.YesNo) == MessageBoxResult.No) return;
        }

        Close();
    }

    private async void Save_Click(object sender, RoutedEventArgs e)
    {
        FileData = _viewModel.CurrentFile;
        IsCancelled = false;
        Close();
    }
    private async void DownloadFile_Click(object sender, RoutedEventArgs e)
    {
        if (_viewModel.Data.Length == 0) return;

        SaveFileDialog saveFileDialog = new()
        {
            FileName = _viewModel.Filename
        };
        if (saveFileDialog.ShowDialog() == true)
        {
            string fileName = saveFileDialog.FileName;
            if(File.Exists(fileName))
            {
                if (MessageBox.Show("Overwrite file?", "File already exists", MessageBoxButton.YesNo) == MessageBoxResult.No) return;
            }

            await File.WriteAllBytesAsync(fileName, _viewModel.Data);
        }
    }

    private async void AttachFile_Click(object sender, RoutedEventArgs e)
    {
        if(_viewModel.Data.Length > 0)
        {
            if (MessageBox.Show("Overwrite file?", "File already exists", MessageBoxButton.YesNo) == MessageBoxResult.No) return;
        }

        OpenFileDialog openFileDialog = new();
        if(openFileDialog.ShowDialog() == true) 
        {
            _viewModel.Data = await File.ReadAllBytesAsync(openFileDialog.FileName);
            if (String.IsNullOrWhiteSpace(_viewModel.Filename)) _viewModel.Filename = openFileDialog.SafeFileName;
            if (String.IsNullOrWhiteSpace(_viewModel.Name)) _viewModel.Name = Path.GetFileNameWithoutExtension(openFileDialog.SafeFileName);
            fileSizeLabel.Visibility = Visibility.Visible;
            buttonDownload.Visibility = Visibility.Visible;
        }
    }
}