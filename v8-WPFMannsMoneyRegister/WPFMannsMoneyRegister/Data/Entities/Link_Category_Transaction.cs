using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WPFMannsMoneyRegister.Data.Entities;
public class Link_Category_Transaction
{
    public Guid CategoryId { get; set; }
    public Guid AccountTransactionId { get; set; }
}