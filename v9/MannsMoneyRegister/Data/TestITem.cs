using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MannsMoneyRegister.Data
{
    public class TestITem
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public decimal Amount { get; set; } = 10359.47m;
        public string BankTransactionText { get; set; } = string.Empty;
        public string ConfirmationNumber { get; set; } = string.Empty;
        public DateTime CreatedOn { get; set; } = DateTime.UtcNow;
        public object? Files { get; set; } = null;
        public string Name { get; set; } = "Transaction Train station";
        public string Notes { get; set; } = "Helping elves attack Graziahr";

        public DateTime? TransactionClearedLocalTime { get; set; } = null;
        public DateTime? TransactionPendingLocalTime { get; set; } = DateTime.UtcNow;

        public decimal Balance { get; set; } = 33459.39M;
        public string CategoryString { get; set; } = "bills, foo-bar, zing-zaddy";
        public int FileCount { get; set;} = 13;
    }
}
