using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;

namespace MoneyRegister.Data.Services;
/// <summary>
/// Service for accessing account information.
/// </summary>
/// <param name="context"></param>
public class AccountService(ApplicationDbContext context)
{
    private readonly ApplicationDbContext _context = context;

    public async Task<Account> CreateAccount(Account account)
    {
        if(account.StartingBalance != account.CurrentBalance) account.CurrentBalance = account.StartingBalance;
        _context.Accounts.Add(account);
        await _context.SaveChangesAsync();

        return account;
    }

    public async Task DeleteAccountAsync(Account account)
    {
        _context.Accounts.Remove(account);
        await _context.SaveChangesAsync();
    }

    /// <summary>
    /// Gets a list of all the accounts.
    /// This should be generally used for drop-downs.
    /// </summary>
    /// <returns></returns>
    public async Task<List<Account>> GetAllAccountsAsync()
    {
        List<Account> accounts = await _context.Accounts.OrderBy(x => x.Name).ToListAsync();

        accounts ??= new List<Account>();
        return accounts;
    }

    /// <summary>
    /// Gets an accounts information including transactions and those transactions categories.
    /// </summary>
    /// <param name="accountId">The guid of the account to get.</param>
    /// <returns>Returns an `Account` that is fully populated.</returns>
    public async Task<Account> GetAccountDetailsAsync(Guid accountId)
    {
        var data = await _context.Accounts
            .Where(x => x.Id == accountId)
            .SingleAsync();


        Account returnData = data;

        return returnData;
    }

    /// <summary>
    /// Re-calculates the balance of all transactions and pending account information.
    /// This should really only be used in very rare situations such as manually messing with the database.
    /// The starting balance is where everything starts from - so that is required to be correct.
    /// </summary>
    /// <param name="account">The guid of the account to re-balance.</param>
    /// <returns>Returns nothing.</returns>
    public async Task RecalculateAccountAsync(Account account)
    {
        var accountTransactions = _context.Transactions.Where(x => x.AccountId == account.Id).ToList();

        decimal balance = account.StartingBalance;
        int outstandingCount = 0;
        decimal outstandingBalance = 0M;

        accountTransactions = accountTransactions.OrderBy(x => x.CreatedOnUTC).ToList();


        foreach (var transaction in accountTransactions)
        {
            transaction.Balance = balance + transaction.Amount;
            balance = transaction.Balance;

            if (transaction.TransactionClearedUTC == null)
            {
                outstandingCount++;
                outstandingBalance += transaction.Amount;
            }
        }

        account.CurrentBalance = balance;
        account.OutstandingBalance = outstandingBalance;
        account.OutstandingItemCount = outstandingCount;

        await _context.SaveChangesAsync();
    }

    public async Task UpdateAccountAsync(Account account)
    {
        _context.Attach(account);
        await _context.SaveChangesAsync();
    }
}