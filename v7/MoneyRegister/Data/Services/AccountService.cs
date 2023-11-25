﻿namespace MoneyRegister.Data.Services;
using Data.Entities;
using Microsoft.EntityFrameworkCore;

public class AccountService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public async Task<List<Account>> GetAllAccountsAsync()
    {
        return await _context.Accounts.ToListAsync();
    }

    public async Task <Account> GetAccountDetailsAsync(Guid accountId)
    {
        var data = await _context.Accounts
            .Include(x => x.Transactions)
            .ThenInclude(x => x.Categories)
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
            if(transaction.Categories.Count > 0)
            {
                Console.WriteLine("Has it: " + transaction.Categories.First().Name);
            }
            if(transaction.Categories.Count > 0)
            {
                foreach(var cat  in transaction.Categories)
                {
                    Console.Write(cat.Name + ":");
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
