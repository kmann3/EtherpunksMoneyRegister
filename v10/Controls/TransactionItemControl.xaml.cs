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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace MannsMoneyRegister.Controls;

/// <summary>
/// Interaction logic for TransactionItemControl.xaml
/// </summary>
public partial class TransactionItemControl : UserControl
{
    public string TransactionName { get; set; } = "Burger King";
    public decimal TransactionAmount { get; set; } = -2049.33M;
    public DateTime? TransactionPendingLocalTime { get; set; } = DateTime.Now;
    public DateTime? TransactionClearedLocalTime { get; set; } = DateTime.Now;
    public string TransactionNotes { get; set; } = String.Empty;
    public string TransactionConfirmationNumber { get; set; } = String.Empty;
    public bool TransactionHasAttachments { get; set; } = false;
    public string TransactionTags { get; set; } = String.Empty;


    public TransactionItemControl()
    {
        InitializeComponent();
        this.DataContext = this;
    }

    private void datagridButtonPendingTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void datagridButtonClearTransaction_Click(object sender, RoutedEventArgs e)
    {

    }

    private void buttonAttachments_Click(object sender, RoutedEventArgs e)
    {

    }
}
