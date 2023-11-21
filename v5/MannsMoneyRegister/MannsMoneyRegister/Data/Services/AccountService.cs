namespace MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using MannsMoneyRegister.Pages.Components;
using Microsoft.EntityFrameworkCore;
using System.Reflection.Metadata;

public class AccountService
{
    private ApplicationDbContext dbContext;

    public AccountService(ApplicationDbContext dbContext)
    {
        this.dbContext = dbContext;
    }

    public async Task<List<Account>> GetAccountListAsync()
    {
        // Outstanding, then by name
        return await dbContext.Accounts.ToListAsync();
    }
    public async Task<Account> GetAccountDetailsAsync(Guid accountId)
    {
        var data =  await dbContext.Accounts
            .Include(x => x.Transactions)
            .Where(x => x.Id == accountId)
            .Select(x => new 
            {
                Account = x,
                Transactions = x.Transactions
                .Where(x => x.DeletedOnUTC == null)
                .Take(100)
                .ToList()
            })            
            .SingleAsync();

        data.Transactions.Sort(new Transaction());
        Account returnData = new();
        returnData = data.Account;
        returnData.Transactions = data.Transactions;

        foreach (var transaction in data.Transactions)
        {
            await dbContext.Entry(transaction).Collection(x => x.Categories).LoadAsync();
        }

        return returnData;
    }

    public async Task CreateNewAccountAsync(Account newAccount)
    {
        dbContext.Accounts.Add(newAccount);
        await dbContext.SaveChangesAsync();
    }

    /// <summary>
    /// Update account details.
    /// </summary>
    /// <param name="account">The account you want to update/</param>
    /// <param name="trueDelete">If true, then this will hard delete the data. This may be wanted if you didn't mean to add an account - such as during the guided intro setup.</param>
    /// <returns></returns>
    public async Task UpdateAccountAsync(Account account, bool trueDelete = false)
    {
        if (account.DeletedOnUTC != null && trueDelete)
        {
            dbContext.Remove(account);
            await dbContext.SaveChangesAsync();
        }
        else
        {
            await dbContext.SaveChangesAsync();
        }
    }

    public async Task RecalculateAccountAsync(Account account)
    {
        var accountTransactions = dbContext.Transactions.Where(x => x.AccountId == account.Id).ToList();

        decimal balance = account.StartingBalance;
        int outstandingCount = 0;
        decimal outstandingBalance = 0M;

        foreach (var transaction in accountTransactions.OrderBy(x => x.CreatedOnUTC))
        {
            transaction.Balance = balance + transaction.Amount;
            balance = transaction.Balance;

            if(transaction.TransactionClearedUTC == null)
            {
                outstandingCount++;
                outstandingBalance += transaction.Amount;
            }
        }

        account.CurrentBalance = balance;
        account.OutstandingBalance = outstandingBalance;
        account.OutstandingItemCount = outstandingCount;

        await dbContext.SaveChangesAsync();
    }
}
