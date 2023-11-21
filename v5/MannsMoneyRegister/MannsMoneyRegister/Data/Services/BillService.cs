namespace MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore;
using System.Reflection.Metadata;

public class BillService
{
    private ApplicationDbContext dbContext;

    public BillService(ApplicationDbContext dbContext)
    {
        this.dbContext = dbContext;
    }

    public async Task<List<Bill>> GetBillListAsync()
    {
        // Outstanding, then by name
        return await dbContext.Bills.Include(x => x.BillGroup).ToListAsync();
    }
    public async Task<List<BillGroup>> GetBillGroupListAsync()
    {
        // Outstanding, then by name
        var billGroups = await dbContext.BillGroups.Include(x => x.Bills).ToListAsync();
        return billGroups;
        //return await dbContext.BillGroups.Include(x => x.Bills).ToListAsync();
    }
    public async Task<List<Bill>> GetUngroupedBillListAsync()
    {
        var ungroupedBills = await dbContext.Bills.Where(x => x.BillGroupId == null).ToListAsync();
        return ungroupedBills;
    }
    public async Task CreateNewBillAsync(Bill newBill)
    {
        dbContext.Bills.Add(newBill);
        await dbContext.SaveChangesAsync();
    }

    public async Task CreateNewBillGroupAsync(BillGroup newBillGroup)
    {
        dbContext.BillGroups.Add(newBillGroup);
        await dbContext.SaveChangesAsync();
    }

    public async Task ReserveBillsAsync(List<Bill> billsToReserve, Account accountToReserveFrom)
    {
        foreach (var bill in billsToReserve)
        {
            Transaction reserveTransaction = new()
            {
                Name = bill.Name,
                Amount = bill.Amount,
                Account = accountToReserveFrom,
                Categories = bill.Categories,
            };

            accountToReserveFrom.CurrentBalance += bill.Amount;
            accountToReserveFrom.OutstandingBalance += bill.Amount;
            accountToReserveFrom.OutstandingItemCount++;
            reserveTransaction.Balance = accountToReserveFrom.CurrentBalance;

            if (bill.NextDueDate != null)
            {
                reserveTransaction.Notes = bill.NextDueDate.Value.ToShortDateString();
            }

            if(bill.BillFrequency != Bill.Regularity.Unknown && bill.BillFrequency != Bill.Regularity.Nonregular)
            {
                // Calculate next due date.
                if(bill.NextDueDate == null)
                {
                    reserveTransaction.Notes = "Due: UNKNOWN (check bill settings)";
                } else
                {
                    reserveTransaction.Notes = $"Due: {bill.NextDueDate.Value.ToShortDateString()}";
                    switch(bill.BillFrequency)
                    {
                        case Bill.Regularity.XDays:
                            if (bill.FrequencyValue == null) throw new Exception("No Frequency Value when one is expected in bill");
                            bill.NextDueDate = bill.NextDueDate.Value.AddDays(bill.FrequencyValue!.Value);
                            break;
                        case Bill.Regularity.Annually:
                            bill.NextDueDate = bill.NextDueDate.Value.AddYears(1);
                            break;
                        case Bill.Regularity.Monthly:
                            bill.NextDueDate = bill.NextDueDate.Value.AddMonths(1);
                            break;
                        default:
                            throw new Exception($"Unexpected case: '{bill.BillFrequency.ToString()}' not taken into account for.");
                    }
                }

            }            
            
            dbContext.Transactions.Add(reserveTransaction);
        }

        await dbContext.SaveChangesAsync();
    }

    /// <summary>
    /// Update bill details.
    /// </summary>
    /// <param name="bill">The bill you want to update/</param>
    /// <param name="trueDelete">If true, then this will hard delete the data. This may be wanted if you didn't mean to add an account - such as during the guided intro setup.</param>
    /// <returns></returns>
    public async Task UpdateBillAsync(Bill bill, bool trueDelete = false)
    {
        if (bill.DeletedOnUTC != null && trueDelete)
        {
            dbContext.Remove(bill);
            await dbContext.SaveChangesAsync();
        }
        else
        {
            await dbContext.SaveChangesAsync();
        }
    }

    /// <summary>
    /// Update bill group details.
    /// </summary>
    /// <param name="billGroup">The bill group you want to update/</param>
    /// <param name="trueDelete">If true, then this will hard delete the data. This may be wanted if you didn't mean to add an account - such as during the guided intro setup.</param>
    /// <returns></returns>
    public async Task UpdateBillGroupAsync(BillGroup billGroup, bool trueDelete = false)
    {
        if (billGroup.DeletedOnUTC != null && trueDelete)
        {
            dbContext.Remove(billGroup);
            await dbContext.SaveChangesAsync();
        }
        else
        {
            await dbContext.SaveChangesAsync();
        }
    }
}
