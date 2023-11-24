using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;

namespace MoneyRegister.Data.Services;

public class CategoryService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    public async Task<List<Category>> GetAllCategoriesAsync()
    {
        return await _context.Categories.OrderBy(x => x.Name).ToListAsync();
    }
}
