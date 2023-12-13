using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;

namespace MoneyRegister.Data.Services;
/// <summary>
/// Service for accessing account information.
/// </summary>
/// <param name="context"></param>
public class AccountService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    private List<Account> _accounts = new();

    /// <summary>
    /// Gets a list of all the accounts.
    /// This should be generally used for drop-downs.
    /// </summary>
    /// <returns></returns>
    public async Task<List<Account>> GetAllAccountsAsync()
    {
        if (_accounts.Count == 0)
        {
            _accounts = await _context.Accounts.OrderBy(x => x.Name).ToListAsync();
        }

        return _accounts;
    }

    /// <summary>
    /// Gets an accounts information including transactions and those transactions categories.
    /// </summary>
    /// <param name="accountId">The guid of the account to get.</param>
    /// <returns>Returns an `Account` that is fully populated.</returns>
    public async Task<Account> GetAccountDetailsAsync(Guid accountId)
    {
        var data = await _context.Accounts
            .Include(x => x.Transactions)
                .ThenInclude(x => x.Categories)
            .Include(x => x.Transactions)
                .ThenInclude(x => x.Files)
            .Where(x => x.Id == accountId)
            .Select(x => new
            {
                Account = x,
                Transactions = x.Transactions
                    .Where(x => x.DeletedOnUTC == null)
                    .ToList(),
            })
            .SingleAsync();

        data.Transactions.Sort(new Transaction());

        Account returnData = data.Account;
        returnData.Transactions = data.Transactions;

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

        foreach (var transaction in accountTransactions.OrderBy(x => x.CreatedOnUTC))
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
}