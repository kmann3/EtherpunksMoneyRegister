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
using WPFMannsMoneyRegister.Windows;
using System.Windows;

namespace WPFMannsMoneyRegister.Controls;
/// <summary>
/// Interaction logic for TransactionItemUserControl.xaml
/// </summary>
public partial class TransactionItemUserControl : UserControl
{
    private List<Account> _accounts = [];
    private List<Category> _categories = [];
    private TransactionItemViewModel _viewModel = new();

    public TransactionItemUserControl()
    {
        InitializeComponent();
        DataContext = _viewModel;
    }

    private async void UserControl_Loaded(object sender, System.Windows.RoutedEventArgs e)
    {
        _accounts = await AppDbService.GetAllAccountsAsync();
        _categories = await AppDbService.GetAllCategoriesAsync();
        transactionAccountComboBox.ItemsSource = _accounts;
        transactionTypeComboBox.ItemsSource = Data.Entities.Base.Enums.GetTransactionTypeEnums;
        transactionFilesListView.ItemsSource = _viewModel.Files;

        //transactionCategoriesListView.ItemsSource = _categories;
    }

    /// <summary>
    /// Load's a transaction.
    /// We clear the DataContext and re-pull the data from the database just in case data was left over from previous transaction as well as forces a loss of data if it's not saved.
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public async Task LoadTransaction(Guid? id)
    {
        DataContext = null;
        if (id == null)
        {
            throw new NotImplementedException("Need to implement creating a new transaction");
        }
        await _viewModel.LoadAccountTransaction(id.Value);
        Visibility = Visibility.Visible;

        DataContext = _viewModel;
        transactionUnselectedCategoriesListView.ItemsSource = _viewModel.UnselectedCategories;
        transactionSelectedCategoriesListView.ItemsSource = _viewModel.SelectedCategories;
        transactionNameTextBox.Focus();
    }

    private void AddFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        var fileWindow = new FileDetails
        {
            title = "Add new file"
        };
        fileWindow.ShowDialog();

        if(!fileWindow.isCancelled)
        {
            var newFile = fileWindow.fileData;
            _viewModel.Files.Add(newFile);
            _viewModel.PropertyFilesChanged();
        }
    }

    private void DeleteFile_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        if (transactionFilesListView.Items.Count == 0) return;
        List<TransactionFile> listToRemove = [];
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

        var fileWindow = new FileDetails
        {
            title = $"File details: {file.Name}"
        };
        fileWindow.ShowDialog();

        if (!fileWindow.isCancelled)
        {
            file = fileWindow.fileData;
            //_viewModel.Files.Add(newFile);
            _viewModel.PropertyFilesChanged();
        }
    }

    private async void SaveTransaction_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        if (!_viewModel.IsChanged) return;

        //await AppDbService.UpdateTransaction(_viewModel.)

        // Get the differences and show them to confirm saving.
    }

    private void transactionCategoriesListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        //e.RemovedItems
        //e.AddedItems
        //_viewModel.PropertyCategoriesChanged();
    }

    private void DeleteTransaction_Click(object sender, System.Windows.RoutedEventArgs e)
    {
        if(MessageBox.Show($"Are you sure you want to delete: {_viewModel.Name}?", "Caption", MessageBoxButton.YesNo) == MessageBoxResult.Yes)
        {
            //_viewModel.DeleteTransaction();
            throw new NotImplementedException();
        }
    }

    private void AddCategoryToTransaction_Click(object sender, RoutedEventArgs e)
    {
        if (transactionUnselectedCategoriesListView.SelectedItem is not Category cat) return;
        _viewModel.UnselectedCategories.Remove(cat);
        _viewModel.SelectedCategories.Add(cat);
        _viewModel.PropertySelectedCategoriesChanged();
        _viewModel.PropertyUnselectedCategoriesChanged();
    }

    private void RemoveCategoryFromTransaction_Click(object sender, RoutedEventArgs e)
    {
        if (transactionSelectedCategoriesListView.SelectedItem is not Category cat) return;
        _viewModel.SelectedCategories.Remove(cat);
        _viewModel.UnselectedCategories.Add(cat);
        _viewModel.PropertySelectedCategoriesChanged();
        _viewModel.PropertyUnselectedCategoriesChanged();
    }

    private void TransactionUnselectedCategoriesListView_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {
        if (transactionUnselectedCategoriesListView.SelectedItem is not Category cat) return;
        _viewModel.UnselectedCategories.Remove(cat);
        _viewModel.SelectedCategories.Add(cat);
        _viewModel.PropertySelectedCategoriesChanged();
        _viewModel.PropertyUnselectedCategoriesChanged();
    }

    private void TransactionSelectedCategoriesListView_MouseDoubleClick(object sender, MouseButtonEventArgs e)
    {
        if (transactionSelectedCategoriesListView.SelectedItem is not Category cat) return;
        _viewModel.SelectedCategories.Remove(cat);
        _viewModel.UnselectedCategories.Add(cat);
        _viewModel.PropertySelectedCategoriesChanged();
        _viewModel.PropertyUnselectedCategoriesChanged();
    }
}
