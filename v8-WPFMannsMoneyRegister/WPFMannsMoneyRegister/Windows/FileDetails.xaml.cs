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
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Windows
{
    /// <summary>
    /// Interaction logic for FileDetails.xaml
    /// </summary>
    public partial class FileDetails : Window
    {
        public bool isCancelled = false;
        public TransactionFile fileData = new();
        public string title = "New File";
        // Add a new file.
        //TransactionFile newFile = new()
        //{
        //    ContentType = "",
        //    Data = new byte[] { },
        //    Filename = "Foo.exe",
        //    Name = "Foo",
        //    Notes = "Notes here",
        //    AccountTransactionId = _viewModel.Id,
        //};

        public FileDetails()
        {
            InitializeComponent();
            Title = title;
        }

        private void Cancel_Click(object sender, RoutedEventArgs e)
        {
            Close();
            isCancelled = true;
        }

        private void Save_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}