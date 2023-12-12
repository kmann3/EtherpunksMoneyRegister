using Microsoft.EntityFrameworkCore;

namespace MoneyRegister.Data.Services;

public class LookupService(ApplicationDbContext context)
{
    private ApplicationDbContext _context = context;
    private List<Entities.Lookup_RecurringTransactionFrequency> _frequencyList = [];
    private List<Entities.Lookup_TransactionType> _typeList = [];

    public async Task<List<Entities.Lookup_RecurringTransactionFrequency>> GetLookup_RecurringTransactionFrequenciesAsync()
    {
        if (_frequencyList.Count == 0)
        {
            _frequencyList = await _context.Lookup_RecurringTransactionFrequencies.ToListAsync();
        }

        return [.. _frequencyList.OrderBy(x => x.Ordinal)];
    }

    public async Task<List<Entities.Lookup_TransactionType>> GetLookup_TransactionTypesAsync()
    {
        if (_typeList.Count == 0)
        {
            _typeList = await _context.Lookup_TransactionTypes.ToListAsync();
        }

        return [.. _typeList.OrderBy(x => x.Ordinal)];
    }
}