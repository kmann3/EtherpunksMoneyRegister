using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using MoneyRegister.Data.Entities.Base;

namespace MoneyRegister.Data.Services;

public class RecurringTransactionService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    /// <summary>
    /// Gets a list of all transaction types.
    /// </summary>
    /// <param name="transactionType">If null, returns everything. Otherwise returns the type requested.</param>
    /// <returns></returns>
    public async Task<List<RecurringTransaction>> GetAllRecurringTransactionsAsync(Enums.TransactionType? transactionType)
    {
        List<RecurringTransaction> list;
        if (transactionType == null)
        {
            list = await _context.RecurringTransactions
                .Include(x => x.Group)
                .Include(x => x.Categories)
                .Include(x => x.PreviousTransactions) // TBI: This might be a bad idea since we only use it for a count. Ideally we should just pull the count. Will need to make a custom class for this though.
                .OrderBy(x => x.TransactionType).ThenBy(x => x.Name)
                .ToListAsync();
        } else
        {
            list = await _context.RecurringTransactions
                .Include(x => x.Group)
                .Include(x => x.Categories)
                .Include(x => x.PreviousTransactions) // TBI: This might be a bad idea since we only use it for a count. Ideally we should just pull the count. Will need to make a custom class for this though.
                .Where(x => x.TransactionType == transactionType)
                .OrderBy(x => x.TransactionType).ThenBy(x => x.Name)
                .ToListAsync();
        }

        return list;
    }

    public async Task<RecurringTransaction> GetRecurringTransactionAsync(Guid id)
    {
        return await _context.RecurringTransactions
                .Include(x => x.Group)
                .Include(x => x.Categories)
                .Include(x => x.PreviousTransactions)
                    .ThenInclude(x => x.Files)
            .Where(x => x.Id == id)
            .SingleAsync();
    }

    public async Task<List<RecurringTransaction>> GetReserveTransactionListAsync()
    {
        return await _context.RecurringTransactions
            .Include(x => x.Group)
            .Include(x => x.Categories)
            .ToListAsync();
    }

    public async Task CreateRecurringTransactionAsync(RecurringTransaction recurringTransaction)
    {
        recurringTransaction.VerifySignage();
        _context.RecurringTransactions.Add(recurringTransaction);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteRecurringTransactionAsync(RecurringTransaction recurringTransaction)
    {
        recurringTransaction.VerifySignage();
        _context.RecurringTransactions.Remove(recurringTransaction);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateRecurringTransactionAsync(RecurringTransaction recurringTransaction)
    {
        recurringTransaction.VerifySignage();
        _context.Attach(recurringTransaction);
        await _context.SaveChangesAsync();
    }
}