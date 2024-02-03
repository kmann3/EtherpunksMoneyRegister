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
using WPFMannsMoneyRegister.Data;
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Windows
{
    /// <summary>
    /// Interaction logic for AddRecurringTransactionWindow.xaml
    /// </summary>
    public partial class AddRecurringTransactionWindow : Window
    {
        public List<RecurringTransaction> SelectedTransactions
        {
            get
            {
                throw new NotImplementedException();
                return null;
            }
        }
        public AddRecurringTransactionWindow()
        {
            InitializeComponent();
        }

        private void Window_Closed(object sender, EventArgs e)
        {
            // Go through all selected items and return
        }

        private async void Window_Loaded(object sender, RoutedEventArgs e)
        {
            recurringTransactionTreeView.Items.Clear();
            var recurringTransactionList = await AppDbService.GetAllRecurringTransactionsAsync();
            var groupList = recurringTransactionList.Where(x => x.Group != null).Select(x => x.Group).Distinct();
            //foreach (var group in groupList.OrderBy(x => x!.Name))
            //{
            //    TreeViewItem item = new TreeViewItem();
            //    item.Header = group.Name;
            //    item.Tag = group;

            //    foreach (var recTran in group.RecurringTransactions.OrderBy(x => x.Name))
            //    {
            //        string displayText = recTran.Name;
            //        if (recTran.NextDueDate != null)
            //        {
            //            displayText += $" (Due: {recTran.NextDueDate.Value.ToShortDateString()})";
            //        }
            //        TreeViewItem childItem = new TreeViewItem();
            //        childItem.Tag = recTran;
            //        childItem.Header = displayText;

            //        item.Items.Add(childItem);
            //    }

            //    recurringTransactionTreeView.Items.Add(item);
            //}


            //TreeViewItem ungroupedRoot = new TreeViewItem();
            //ungroupedRoot.Header = "Ungrouped Bills";
            //ungroupedRoot.Tag = null;

            //foreach (var recTran in recurringTransactionList.Where(x => x.Group == null).OrderBy(x => x.Name))
            //{
            //    string displayText = recTran.Name;
            //    if (recTran.NextDueDate != null)
            //    {
            //        displayText += $" (Due: {recTran.NextDueDate.Value.ToShortDateString()})";
            //    }

            //    TreeViewItem ungroupedChild = new TreeViewItem();
            //    ungroupedRoot.Header = displayText;
            //    ungroupedChild.Tag = recTran;
            //    ungroupedRoot.Items.Add(ungroupedChild);
            //}

            //recurringTransactionTreeView.Items.Add(ungroupedRoot);
        }
    }
}
