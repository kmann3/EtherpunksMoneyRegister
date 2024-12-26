using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace MannsMoneyRegister.Controls;
/// <summary>
/// Interaction logic for TransactionListControl.xaml
/// </summary>
public partial class TransactionListControl : UserControl
{

    public int ItemCount = 5;
    public List<TransactionItemControl> ControlList = new();
    private int index = 1;
    
    public TransactionListControl()
    {
        InitializeComponent();
        this.DataContext = this;

        TransactionItemControl.TransactionItem TransactionItem1 = new()
        {
            Name = "Burger King",
            Amount = -12.39m,
            Balance = 1879.31m,
            Tags = "fast-food",
            PendingLocalTime = DateTime.Now.AddDays(-2),
            ClearedLocalTime = DateTime.Now,
            HasAttachments = false,
        };

        TransactionItem1.Name = "Burger King";
        TransactionItem1.Amount = -12.39m;
        TransactionItem1.Balance = 1879.31m;
        TransactionItem1.Tags = "fast-food";
        TransactionItem1.PendingLocalTime = DateTime.Now.AddDays(-2);
        TransactionItem1.ClearedLocalTime = DateTime.Now;
        TransactionItem1.HasAttachments = false;

        TransactionItemControl.TransactionItem TransactionItem2 = new()
        {
            Name = "AT&T",
            Amount = -87.76m,
            Balance = 1797.83m,
            Tags = "bills",
            PendingLocalTime = DateTime.Now.AddDays(-1),
            ClearedLocalTime = null,
            HasAttachments = true,
            ConfirmationNumber = "1kdnz983lM"
        };

        TransactionItemControl.TransactionItem TransactionItem3 = new()
        {
            Name = "iCloud",
            Amount = -12.39m,
            Balance = 1795m,
            Tags = "bills",
            PendingLocalTime = null,
            ClearedLocalTime = null,
            HasAttachments = false,
        };

        TransactionItemControl.TransactionItem TransactionItem4 = new()
        {
            Name = "ASDFasd",
            Amount = -12.39m,
            Balance = 1795m,
            Tags = "",
            PendingLocalTime = DateTime.Now,
            ClearedLocalTime = DateTime.Now,
            HasAttachments = false,
        };

        TransactionItemControl newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem1;

        newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem1;

        newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem2;

        newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem2;

        newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem3;

        newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem3;

        newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem4;

        newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem4;

        newControl = new();
        if (index++ % 2 == 0) newControl.IsAlternateRow = true;
        StackPanelList.Children.Add(newControl);
        newControl.Item = TransactionItem4;
    }
}
