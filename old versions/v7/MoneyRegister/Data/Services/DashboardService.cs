using Microsoft.EntityFrameworkCore;
using MoneyRegister.Data.Entities;
using MudBlazor;

namespace MoneyRegister.Data.Services;

public class DashboardService(ApplicationDbContext context)
{
    public class DashboardItem
    {
        public Guid Id { get; set; } = Guid.Empty;
        public string Name { get; set; } = string.Empty;
        public decimal CurrentBalance { get; set; } = 0M;
        public string OutstandingSummary { get; set; } = string.Empty;
        public DateTime? LastBalanced { get; set; } = null;
    }

    public class DashboardNotificationItem
    {
        public Color Severity { get; set; }
        public RecurringTransaction NotificationRecurringTransaction { get; set; }
        public bool IsLate { get; set; } = false;
        public DateTime DueDate { get; set; }
    }

    private ApplicationDbContext _context = context;

    public async Task<List<DashboardNotificationItem>> GetAllNotifications()
    {
        var recurringTransactions = await _context.RecurringTransactions.ToListAsync();

        foreach(var recurringTransaction in recurringTransactions)
        { 
            if(recurringTransaction.NextDueDate != null)
            {
                // Are we late or is it coming soon?
                if(DateTime.UtcNow >  recurringTransaction.NextDueDate)
                {
                    // We are late
                    DashboardNotificationItem dashboardNotificationItem = new DashboardNotificationItem()
                    {
                        Severity = Color.Error,
                        NotificationRecurringTransaction = recurringTransaction,
                        DueDate = recurringTransaction.NextDueDate.Value,
                        IsLate = true,
                    };
                } else if ((recurringTransaction.NextDueDate-DateTime.UtcNow).Value.Days < 14)
                {
                    // something is due in the next 14 days
                    DashboardNotificationItem dashboardNotificationItem = new DashboardNotificationItem()
                    {
                        Severity = Color.Warning,
                        NotificationRecurringTransaction = recurringTransaction,
                        DueDate = recurringTransaction.NextDueDate.Value,
                        IsLate = false,
                    };
                }
                
            }
        }

        return new List<DashboardNotificationItem>();
    }


    public async Task<List<DashboardItem>> GetDashboardItemsAsync()
    {
        return await _context.Accounts.Select(x => new DashboardItem
        {
            Id = x.Id,
            Name = x.Name,
            CurrentBalance = x.CurrentBalance,
            OutstandingSummary = x.OutstandingSummary,
            LastBalanced = x.LastBalancedLocalTime,
        }).ToListAsync();
    }
}