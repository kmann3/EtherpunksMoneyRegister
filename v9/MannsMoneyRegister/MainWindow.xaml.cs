using MannsMoneyRegister.Data;
using System.Diagnostics;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace MannsMoneyRegister;

/// <summary>
/// Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{
    private List<TestITem> testing = new();
    public MainWindow()
    {
        this.InitializeComponent();
        testing.Add(new TestITem());
        testing.Add(new TestITem());
        testing.Add(new TestITem());
        testing.Add(new TestITem());
        testing.Add(new TestITem());
        testing.Add(new TestITem());

        Trace.WriteLine($"{RibbonTest.Background.ToString()}");

        dataGridTransactions.ItemsSource = testing;
    }

    private void ribbonComboBox_Dashboard_AccountSelection_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {

    }

    private void ribbonComboBox_Dashboard_DayCount_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {

    }

    private void ribbonButton_Dashboard_CustomRange_Click(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonButton_Dashboard_NewTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonButton_Dashboard_NewAccount_Click(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonCheckBox_Dashboard_Autoload_Checked(object sender, RoutedEventArgs e)
    {

    }

    private void ribbonButton_Dashboard_ReserveTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void dataGridTransactions_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {

    }

    private void buttonSaveTransaction_Click(object sender, RoutedEventArgs e)
    {

    }
}