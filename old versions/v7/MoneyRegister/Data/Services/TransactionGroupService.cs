using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;

namespace MoneyRegister.Data.Services;

public class TransactionGroupService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    private List<TransactionGroup> _transactionGroups = new();

    public async Task<List<TransactionGroup>> GetAllTransactionGroupsAsync()
    {
        if (_transactionGroups.Count == 0)
        {
            _transactionGroups = await _context.TransactionGroups.OrderBy(x => x.Name).ToListAsync();
        }

        return _transactionGroups;
    }
}