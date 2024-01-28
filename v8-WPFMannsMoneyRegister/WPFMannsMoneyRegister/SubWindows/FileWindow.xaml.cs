using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace WPFMannsMoneyRegister.SubWindows;
/// <summary>
/// Interaction logic for FileWindow.xaml
/// </summary>
public partial class FileWindow : Window
{
    public FileWindow()
    {
        InitializeComponent();
        Owner = App.Current.MainWindow;
    }
}
