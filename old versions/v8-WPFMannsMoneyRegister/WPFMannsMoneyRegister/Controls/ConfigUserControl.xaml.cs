using System.Configuration;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using WPFMannsMoneyRegister.Data;

namespace WPFMannsMoneyRegister.Controls;

/// <summary>
/// Interaction logic for ConfigUserControl.xaml
/// </summary>
public partial class ConfigUserControl : UserControl
{
    private List<Data.Entities.Account> _allAccounts = [];
    public ConfigUserControl()
    {
        InitializeComponent();
    }

    private async void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        _allAccounts = await AppDbService.GetAllAccountsAsync();
        defaultAccountComboBox.ItemsSource = _allAccounts;

        string db = ConfigurationManager.AppSettings["databaseLocation"] ?? "";
        databaseLocationTextBox.Text = db;

        //Guid? defaultAccountId = ConfigurationManager.AppSettings["defaultAccountId"] as Guid? ?? Guid.Empty;
        //var transData = DataGridTransactions.SelectedItem as AccountTransaction ?? throw new Exception("Transaction data is null.");
        string defaultAccountIdString = ConfigurationManager.AppSettings[""] ?? "";
        _ = Guid.TryParse(defaultAccountIdString, out Guid defaultAccountId);

    }

    private void LoadDatabaseButton_Click(object sender, RoutedEventArgs e)
    {
        //Configuration oConfig = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
        //oConfig.AppSettings.Settings["databaseLocation"].Value = $"d:\\src\\wpfMMR.sqlite32";
        //oConfig.Save(ConfigurationSaveMode.Full);
        //ConfigurationManager.RefreshSection("appSettings");
        //string db = ConfigurationManager.AppSettings["databaseLocation"] ?? "";

        //Trace.WriteLine(db);

        //--------------------------

        // See if we have a specified location. If not, then fall back to the default file.
        //string db = ConfigurationManager.AppSettings["databaseLocation"] ?? "";
        //if (String.IsNullOrEmpty(db))
        //{
        //    db = "";
        //}
        //else if (!System.IO.File.Exists(db))
        //{
        //    // File doesn't exist
        //    throw new System.IO.FileNotFoundException(db);
        //}

        //AppDbService.LoadDatabaseAsync(db);
        throw new NotImplementedException();
    }

    private void DefaultAccountComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        Trace.WriteLine(((Guid)defaultAccountComboBox.SelectedValue).ToString());
        throw new NotImplementedException();
    }

    private void SaveButton_Click(object sender, RoutedEventArgs e)
    {
        throw new NotImplementedException();
    }

}
