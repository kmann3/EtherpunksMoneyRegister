namespace MoneyRegister.Data.Services;
using Data.Entities;
using Microsoft.EntityFrameworkCore;

public class AccountService
{
    private ApplicationDbContext _context;

    public AccountService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task <Account> GetAccountDetailsAsync(Guid accountId)
    {
        var data = await _context.Accounts
            .Include(x => x.Transactions)
                .ThenInclude(x => x.Link_Category_Transactions).ThenInclude(x => x.Category)
            .Where(x => x.Id == accountId)
            .Select(x => new
            {
                Account = x,
                Transactions = x.Transactions
                    .Where(x => x.DeletedOnUTC == null)
                    //.Take(100)
                    .ToList()
            })
            .SingleAsync();

        data.Transactions.Sort(new Transaction());

        Account returnData = data.Account;
        returnData.Transactions = data.Transactions;

        foreach(var transaction in data.Transactions)
        {
            //await _context.Entry(transaction).Collection(x => x.Categories).LoadAsync();
            Console.Write(transaction.Name + "--");
            if(transaction.Link_Category_Transactions.Count > 0)
            {
                Console.WriteLine("Has it: " + transaction.Link_Category_Transactions.First().Category.Name);
            }
            if(transaction.Link_Category_Transactions.Count > 0)
            {
                foreach(var cat  in transaction.Link_Category_Transactions)
                {
                    Console.Write(cat.Category.Name + ":");
                }
            } else
            {
                Console.Write("none");
            }

            Console.WriteLine();
        }

        return returnData;
    }
}
