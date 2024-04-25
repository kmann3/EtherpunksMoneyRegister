using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
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
    private static Regex RegEx_Numeric = new Regex(@"[0-9.$,-]");

    public class TransactionItem
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Name { get; set; } = string.Empty;
        public decimal Amount { get; set; } = 0m;
        public decimal Balance { get; set; } = 0m;
        public bool IsPending
        {
            get
            {
                return PendingLocalTime == null && ClearedLocalTime != null;
            }
        }
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

    private Brush _backgroundCurrentColor = Brushes.AliceBlue;

    /// <summary>
    /// The primary background of the transaction.ds
    /// </summary>
    private Brush _backgroundPrimaryColor = Brushes.AliceBlue;

    /// <summary>
    /// The alternate background of the transaction.
    /// </summary>
    private Brush _backgroundAlternateColor = Brushes.Beige;

    /// <summary>
    /// This is used for transactions that are pending but not yet cleared.
    /// </summary>
    private Brush _background_pending = Brushes.DarkKhaki;

    /// <summary>
    ///  This is used if there is no pending and no cleared date. The transaction is reserved. This is usually used for things like bills or expected recurring transactions.
    /// </summary>
    private Brush _background_reserved = Brushes.Salmon;

    private void SetBackground()
    {
        if (Item.ClearedLocalTime == null && Item.PendingLocalTime.HasValue) _backgroundCurrentColor = _background_pending;
        else if (Item.ClearedLocalTime == null && Item.PendingLocalTime == null) _backgroundCurrentColor = _background_reserved;
        else if (_isAlternateRow) _backgroundCurrentColor = _backgroundAlternateColor;
        else _backgroundCurrentColor = _backgroundPrimaryColor;

        this.BackgroundBorder.Background = _backgroundCurrentColor;
        this.TextBoxName.Background = _backgroundCurrentColor;
        this.TextBoxAmount.Background = _backgroundCurrentColor;
        this.TextBoxNotes.Background = _backgroundCurrentColor;
        this.TextBoxConfirmationNumber.Background = _backgroundCurrentColor;
        this.TextBlockAttachments.Background = _backgroundCurrentColor;
        //this.PendingDatePicker.Background = _backgroundCurrentColor;

        if (Item.PendingLocalTime == null && Item.ClearedLocalTime == null)
        {
            // Reserved

            // Pending
            ButtonPendingTransaction.Visibility = Visibility.Visible;
            TextBlockPendingLocalTime.Visibility = Visibility.Hidden;

            // Cleared
            ButtonClearedTransaction.Visibility = Visibility.Visible;
            TextBlockClearedLocalTime.Visibility = Visibility.Hidden;
        } else if(Item.PendingLocalTime != null && Item.ClearedLocalTime == null)
        {
            // Pending
            // Pending
            ButtonPendingTransaction.Visibility = Visibility.Hidden;
            TextBlockPendingLocalTime.Visibility = Visibility.Visible;

            // Cleared
            ButtonClearedTransaction.Visibility = Visibility.Visible;
            TextBlockClearedLocalTime.Visibility = Visibility.Hidden;

        }
        else
        {
            // Cleared

            // Pending
            ButtonPendingTransaction.Visibility = Visibility.Hidden;
            TextBlockPendingLocalTime.Visibility = Visibility.Visible;

            // Cleared
            ButtonClearedTransaction.Visibility = Visibility.Hidden;
            TextBlockClearedLocalTime.Visibility = Visibility.Visible;

        }

        if(Item.HasAttachments)
        {
            TextBlockAttachments.Visibility = Visibility.Visible;
            TextBlockAttachments.ToolTip = "There are 12 attachments";
        } else
        {
            TextBlockAttachments.Visibility = Visibility.Hidden;
        }
    }


    public TransactionItemControl()
    {
        InitializeComponent();
        this.DataContext = this;
    }

    private void ButtonPendingTransaction_Click(object sender, RoutedEventArgs e)
    {
        this.Item.PendingLocalTime = DateTime.Now;
        ButtonPendingTransaction.Visibility = Visibility.Hidden;
        TextBlockPendingLocalTime.Visibility = Visibility.Visible;
        TextBlockPendingLocalTime.Text = this.Item.PendingLocalTime.ToString();
        SetBackground();
    }

    private void ButtonClearTransaction_Click(object sender, RoutedEventArgs e)
    {
        this.Item.ClearedLocalTime = DateTime.Now;
        ButtonClearedTransaction.Visibility = Visibility.Hidden;
        ButtonPendingTransaction.Visibility = Visibility.Hidden;
        TextBlockClearedLocalTime.Visibility = Visibility.Visible;
        TextBlockClearedLocalTime.Text = this.Item.ClearedLocalTime.ToString();
        SetBackground();
    }


    private void Object_GotFocus(object sender, RoutedEventArgs e)
    {
        if(sender is TextBox)
            ((TextBox)(e.Source)).Background = Brushes.White;
    }

    private void Object_LostFocus(object sender, RoutedEventArgs e)
    {
        if (sender is TextBox)
            ((TextBox)(e.Source)).Background = _backgroundCurrentColor;
    }

    private void TextBoxAmount_PreviewTextInput(object sender, TextCompositionEventArgs e)
    {
        e.Handled = !RegEx_Numeric.IsMatch(e.Text);
    }

    private void PendingTextBlock_MouseDown(object sender, MouseButtonEventArgs e)
    {
        //PendingCalendar.IsOpen = true;
    }

    private void OnMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
    {

    }

    private void PendingDatePicker_GotFocus(object sender, RoutedEventArgs e)
    {

    }

    private void PendingDatePicker_LostFocus(object sender, RoutedEventArgs e)
    {

    }
}
