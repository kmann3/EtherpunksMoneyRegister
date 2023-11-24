using Microsoft.EntityFrameworkCore;
using System.Transactions;

namespace MoneyRegister.Data.Services;

public class TestService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public async Task DoThing()
    {
        Entities.Category firstTransaction = await _context.Categories.FirstAsync();

        _context.Categories.Remove(firstTransaction);
        await _context.SaveChangesAsync();

    }
}
