namespace MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore;

public class LookupService
{
    private ApplicationDbContext dbContext;

    public LookupService(ApplicationDbContext dbContext)
    {
        this.dbContext = dbContext;
    }

    public async Task<List<Category>> GetAllCategoriesAsync()
    {
        return await dbContext.Categories.OrderBy(x => x.Name).ToListAsync();
    }

    public async Task<List<Entities.Account>> GetAllAccountsAsync()
    {
        return await dbContext.Accounts.OrderBy(x => x.Name == "Cash").ThenBy(x => x.Name).ToListAsync();
    }
}
