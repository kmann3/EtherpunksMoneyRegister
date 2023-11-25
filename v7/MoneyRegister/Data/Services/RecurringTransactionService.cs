using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
namespace MoneyRegister.Data.Services;

public class RecurringTransactionService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public async Task<List<Entities.RecurringTransaction>> GetAllRecurringTransactionsAsync()
    {
        return await _context.RecurringTransactions
            .Include(x => x.Group)
            .Include(x => x.Categories)
            .OrderBy(x => x.TransactionType).ThenBy(x => x.Name)
            .ToListAsync();
    }

    public async Task DeleteRecurringTransactionAsync(RecurringTransaction recurringTransaction)
    {
        _context.RecurringTransactions.Remove(recurringTransaction);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateRecurringTransactionAsync(RecurringTransaction recurringTransaction)
    {
        _context.Attach(recurringTransaction);
        await _context.SaveChangesAsync();
    }
}
