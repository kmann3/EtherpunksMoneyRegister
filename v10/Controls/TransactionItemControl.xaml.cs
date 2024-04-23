using System;
using System.Collections.Generic;
using System.Diagnostics;
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
    public class TransactionItem
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Name { get; set; } = string.Empty;
        public decimal Amount { get; set; } = 0m;
        public string AmountString { get { return $"{Amount.ToString("C")}"; } }
        public decimal Balance { get; set; } = 0m;
        public string BalanceString{ get { return $"{Balance.ToString("C")}"; } }
        public DateTime? PendingLocalTime { get; set; } = null;
        public DateTime? ClearedLocalTime { get; set; } = null;
        private string _notes = string.Empty;
        public string Notes { get { return _notes == string.Empty ? "" : $"N: {_notes}"; } set { _notes = value; } }

        private string _confirmationNumber = string.Empty;
        public string ConfirmationNumber { get { return _confirmationNumber == string.Empty ? "" : $"C: {_confirmationNumber}"; } set { _confirmationNumber = value; } }
        public bool HasAttachments { get; set; } = false;

        private string _tags = string.Empty;
        public string Tags { get { return _tags == string.Empty ? "" : $"T: {_tags}"; } set { _tags = value; } }

    }
    private TransactionItem _transactionItem = new();
    public TransactionItem Item { get { return _transactionItem; } set { _transactionItem = value; SetBackground(); } }


    public bool IsAlternateRow
    {
        get
        {
            return _isAlternateRow;
        }
        set
        {
            _isAlternateRow = value;


        }
    }
    private bool _isAlternateRow = false;

    private Brush _backgroundColor = Brushes.AliceBlue;

    private void SetBackground()
    {
        if (_isAlternateRow && Item.ClearedLocalTime == null && Item.PendingLocalTime == null) _backgroundColor = Brushes.Red;
        else if (_isAlternateRow && Item.ClearedLocalTime == null && Item.PendingLocalTime.HasValue) _backgroundColor = Brushes.Peru;
        else if (_isAlternateRow && Item.ClearedLocalTime.HasValue && Item.PendingLocalTime.HasValue) _backgroundColor = Brushes.Beige;
        else if (!_isAlternateRow && Item.ClearedLocalTime == null && Item.PendingLocalTime == null) _backgroundColor = Brushes.Salmon;
        else if (!_isAlternateRow && Item.ClearedLocalTime == null && Item.PendingLocalTime.HasValue) _backgroundColor = Brushes.Yellow;

        this.BackgroundBorder.Background = _backgroundColor;
        this.TextBoxName.Background = _backgroundColor;
        this.TextBoxAmount.Background = _backgroundColor;
    }


    public TransactionItemControl()
    {
        InitializeComponent();
        this.DataContext = this;
    }

    private void datagridButtonPendingTransaction_Click(object sender, RoutedEventArgs e)
    {
        Trace.WriteLine($"Pending Transaction Button Clicked: {Item.Name}");
    }

    private void datagridButtonClearTransaction_Click(object sender, RoutedEventArgs e)
    {
        Trace.WriteLine($"Clear Transaction Button Clicked: {Item.Name}");
    }

    private void GridControl_MouseWheel(object sender, MouseWheelEventArgs e)
    {
        Trace.WriteLine($"Mouse Wheel: {e.Delta}");
    }

    private void GridControl_MouseDown(object sender, MouseButtonEventArgs e)
    {
        Trace.WriteLine($"Mouse down {e.ClickCount}");
    }

    private void TextBoxName_GotFocus(object sender, RoutedEventArgs e)
    {
        ((TextBox)(e.Source)).Background = Brushes.White;
    }

    private void TextBoxName_LostFocus(object sender, RoutedEventArgs e)
    {
        ((TextBox)(e.Source)).Background = _backgroundColor;
    }

    private void TextBoxAmount_GotFocus(object sender, RoutedEventArgs e)
    {
        ((TextBox)(e.Source)).Background = Brushes.White;
    }

    private void TextBoxAmount_LostFocus(object sender, RoutedEventArgs e)
    {
        ((TextBox)(e.Source)).Background = _backgroundColor;
    }

    private void TextBoxName_MouseWheel(object sender, MouseWheelEventArgs e)
    {
        // Fire the "user is scrolling" event
        Trace.WriteLine($"{e.Delta}");
    }
}
