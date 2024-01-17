using System.Diagnostics;
using System.Windows.Controls;
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Controls;
/// <summary>
/// Interaction logic for TransactionItemUserControl.xaml
/// </summary>
public partial class TransactionItemUserControl : UserControl
{
    public TransactionItemUserControl()
    {
        InitializeComponent();
    }

    public async Task LoadTransaction(Transaction transaction)
    {
        transactionNameTextBox.Text = transaction.Name;
        transactionNameTextBox.Focus();
        List<FooItem> fooItems = new List<FooItem>();
        fooItems.Add(new FooItem()
        {
            Filename = "Report.zip",
            Size = "10MB",
            Notes = string.Empty,
            CreatedOn = DateTime.Now.AddDays(-30),
        });
        fooItems.Add(new FooItem()
        {
            Filename = "invoice.pdf",
            Size = "1MB",
            Notes = "Invoice for thing with blah de blah",
            CreatedOn = DateTime.Now,
        });

        transactionFilesListView.ItemsSource = fooItems;
        //transactionFilesListView
    }

    private class FooItem
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Filename { get; set; }    
        public string Size { get; set; }
        public string Notes { get; set; }
        public DateTime CreatedOn { get; set; } = DateTime.Now;
    }
}
