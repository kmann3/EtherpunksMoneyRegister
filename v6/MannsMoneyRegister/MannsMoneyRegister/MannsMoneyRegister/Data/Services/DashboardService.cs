using Microsoft.EntityFrameworkCore;

namespace MannsMoneyRegister.Data.Services;

public class DashboardService
{
    public class DashboardItem
    {
        public Guid Id { get; set; } = Guid.Empty;
        public string Name { get; set;} = string.Empty;
        public decimal CurrentBalance { get; set; } = 0M;
        public string OutstandingSummary { get; set; } = string.Empty;
        public DateTime? LastBalanced { get; set; } = null;
    }

    private ApplicationDbContext _context;

    public DashboardService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<List<DashboardItem>> GetDashboardItemsAsync()
    {
        return await _context.Accounts.Select(x => new DashboardItem
        {
            Id = x.Id,
            Name = x.Name,
            CurrentBalance = x.CurrentBalance,
            OutstandingSummary = x.OutstandingSummary,
            LastBalanced = x.LastBalancedLocalTime
        }).ToListAsync();
    }
}
