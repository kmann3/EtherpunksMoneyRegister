using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;

namespace MoneyRegister.Data.Services;

public class CategoryService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;

    private List<Category> _categories = new();

    public async Task<List<Category>> GetAllCategoriesAsync()
    {
        if(_categories.Count == 0)
        {
            _categories = await _context.Categories.OrderBy(x => x.Name).ToListAsync();
        }

        return _categories;
    }
}
