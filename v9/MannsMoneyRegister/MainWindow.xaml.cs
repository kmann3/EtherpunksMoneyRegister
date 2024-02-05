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
        InitializeComponent();
        testing.Add(new TestITem());
        testing.Add(new TestITem());
        testing.Add(new TestITem());
        testing.Add(new TestITem());
        testing.Add(new TestITem());
        testing.Add(new TestITem());

        DataGridTransactions.ItemsSource = testing;
    }

    private void RibbonGallery_SelectionChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
    {
        Trace.WriteLine($"What?");
    }
}