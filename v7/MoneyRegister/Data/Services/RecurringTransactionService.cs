using Microsoft.EntityFrameworkCore;
namespace MoneyRegister.Data.Services;

public class RecurringTransactionService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public async Task<List<Entities.RecurringTransaction>> GetAllRecurringTransactionsAsync()
    {
        return await _context.RecurringTransactions
            .Include(x => x.Group)
            .Include(x => x.Link_Category_RecurringTransactions).ThenInclude(x => x.Category)
            .OrderBy(x => x.TransactionType).ThenBy(x => x.Name)
            .ToListAsync();
    }
}
