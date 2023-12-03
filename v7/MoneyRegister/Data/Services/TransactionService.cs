using Microsoft.EntityFrameworkCore;
using MoneyRegister.Components.Pages;
using MoneyRegister.Data.Entities;
namespace MoneyRegister.Data.Services;

public class TransactionService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public async Task CreateTransactionAsync(Transaction transaction)
    {
        _context.Transactions.Add(transaction);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteTransactionAsync(Transaction transaction, bool isHardDelete)
    {
        if (isHardDelete) _context.Transactions.Remove(transaction);
        else _context.Attach(transaction);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateTransactionAsync(Transaction transaction)
    {
        _context.Attach(transaction);
        await _context.SaveChangesAsync();
    }
}
