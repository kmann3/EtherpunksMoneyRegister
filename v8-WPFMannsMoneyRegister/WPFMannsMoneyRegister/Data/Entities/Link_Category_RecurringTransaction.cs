using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WPFMannsMoneyRegister.Data.Entities;

public class Link_Category_RecurringTransaction
{
    public Guid CategoryId { get; set; }
    public Guid RecurringTransactionId { get; set; }
}