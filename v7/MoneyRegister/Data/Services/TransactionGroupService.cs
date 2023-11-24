using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;

namespace MoneyRegister.Data.Services;

public class TransactionGroupService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public async Task<List<TransactionGroup>> GetAllTransactionGroupsAsync()
    {
        return await _context.TransactionGroups.OrderBy(x => x.Name).ToListAsync();
    }
}
