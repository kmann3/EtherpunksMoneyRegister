using MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using MannsMoneyRegister.Data.Entities.Base;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Security.Principal;
using System.Transactions;
using System.Windows;

namespace MannsMoneyRegister;

public class MainWindowViewModel : INotifyPropertyChanged
{
    private AccountTransaction _currentTansactionVersion = new();
    private ObservableCollection<AccountTransactionFile> _files = new();
    private bool _isNew = false;
    private AccountTransaction _previousTransactionVersion = new();
    private ObservableCollection<Tag> _selectedTags = [];
    private ObservableCollection<Tag> _unselectedTags = [];

    public MainWindowViewModel()
    {
               
    }

    public event EventHandler<bool> HasChangedFromOriginal;

    public event PropertyChangedEventHandler? PropertyChanged;

    public Guid AccountId
    {
        get => _currentTansactionVersion.AccountId;
        set
        {
            if (_currentTansactionVersion.AccountId == value) return;
            _currentTansactionVersion.AccountId = value;
            OnPropertyChanged(nameof(AccountId));
        }
    }

    public List<Account> AccountList
    {
        get
        {
            return AppService.AccountList;
        }
    }

    public decimal Amount
    {
        get => _currentTansactionVersion.Amount;
        set
        {
            if (_currentTansactionVersion.Amount == value) return;
            _currentTansactionVersion.Amount = value;
            OnPropertyChanged(nameof(Name));
        }
    }

    public decimal Balance
    {
        get => _currentTansactionVersion.Balance;
        set
        {
            if (_currentTansactionVersion.Balance == value) return;
            _currentTansactionVersion.Balance = value;
            OnPropertyChanged(nameof(Balance));
        }
    }

    public string BankTransactionText
    {
        get => _currentTansactionVersion.BankTransactionText;
        set
        {
            if (_currentTansactionVersion.BankTransactionText == value) return;
            _currentTansactionVersion.BankTransactionText = value;
            OnPropertyChanged(nameof(BankTransactionText));
        }
    }

    public string ConfirmationNumber
    {
        get => _currentTansactionVersion.ConfirmationNumber;
        set
        {
            if (_currentTansactionVersion.ConfirmationNumber == value) return;
            _currentTansactionVersion.ConfirmationNumber = value;
            OnPropertyChanged(nameof(ConfirmationNumber));
        }
    }

    public DateTime CreatedOn
    {
        get => _currentTansactionVersion.CreatedOnLocalTime;
    }

    public AccountTransaction CurrentTransaction
    {
        get
        {
            return _currentTansactionVersion;
        }
        set
        {
            _currentTansactionVersion = value;
            _previousTransactionVersion = _currentTansactionVersion.DeepClone();
        }
    }

    public string DefaultSearchDayCount { get; } = AppService.DefaultSearchDayCount;

    public DateTime DefaultSearchDayCustomEnd { get; } = AppService.DefaultSearchDayCustomEnd;

    public DateTime DefaultSearchDayCustomStart { get; } = AppService.DefaultSearchDayCustomStart;

    public DateTime? DueDate
    {
        get => _currentTansactionVersion.DueDate;
        set
        {
            if (_currentTansactionVersion.DueDate == value) return;

            _currentTansactionVersion.DueDate = value;
            OnPropertyChanged(nameof(DueDate));
        }
    }

    public ObservableCollection<AccountTransactionFile> Files
    {
        get => _files;
        set
        {

        }
    }

    public Guid Id
    {
        get => _currentTansactionVersion.Id;
    }

    public bool IsChanged
    {
        get
        {
            return !_previousTransactionVersion.DeepEquals(_currentTansactionVersion);
        }
    }

    public bool IsNew
    {
        get
        {
            return _isNew;
        }
    }

    public Account LoadedAccount { get; set; } = new();

    public string Name
    {
        get => _currentTansactionVersion.Name;
        set
        {
            if (_currentTansactionVersion.Name == value) return;

            _currentTansactionVersion.Name = value;
            OnPropertyChanged(nameof(Name));
        }
    }

    public string Notes
    {
        get => _currentTansactionVersion.Notes;
        set
        {
            if (_currentTansactionVersion.Notes == value) return;

            _currentTansactionVersion.Notes = value;
            OnPropertyChanged(nameof(Notes));
        }
    }

    public ObservableCollection<Tag> SelectedTags
    {
        get
        {
            if (_selectedTags == null || _selectedTags.Count == 0)
            {
                _selectedTags = [.. _currentTansactionVersion.Tags.OrderBy(x => x.Name)];
            }

            return _selectedTags;
        }
        set
        {
            _selectedTags = value;
            OnPropertyChanged(nameof(_selectedTags));
        }
    }

    public DateTime? TransactionCleared
    {
        get => _currentTansactionVersion.TransactionClearedLocalTime;
        set
        {
            if (_currentTansactionVersion.TransactionClearedLocalTime == value) return;

            _currentTansactionVersion.TransactionClearedLocalTime = value;
            OnPropertyChanged(nameof(TransactionCleared));
        }
    }

    public DateTime TransactionEndDate { get; set; } = AppService.DefaultSearchDayCustomStart;

    public DateTime? TransactionPending
    {
        get => _currentTansactionVersion.TransactionPendingLocalTime;
        set
        {
            if (_currentTansactionVersion.TransactionPendingLocalTime == value) return;

            _currentTansactionVersion.TransactionPendingLocalTime = value;
            OnPropertyChanged(nameof(TransactionPending));
        }
    }

    public List<AccountTransaction> Transactions { get; set; } = new();

    public DateTime TransactionStartDate { get; set; } = AppService.DefaultSearchDayCustomEnd;

    public Enums.TransactionTypeEnum TransactionType
    {
        get => _currentTansactionVersion.TransactionType;
        set
        {
            if (_currentTansactionVersion.TransactionType == value) return;

            _currentTansactionVersion.TransactionType = value;
            OnPropertyChanged(nameof(TransactionType));
        }
    }

    public ObservableCollection<Tag> UnselectedTags
    {
        get
        {
            if (_unselectedTags == null || _unselectedTags.Count == 0)
            {
                _unselectedTags = [];
                foreach (Tag? tag in AppService.AllTags.OrderBy(x => x.Name))
                {
                    if (!_currentTansactionVersion.Tags.Any(x => x.Name == tag.Name))
                    {
                        _unselectedTags.Add(tag);
                    }
                }
            }
            return _unselectedTags;
        }
        set
        {
            _unselectedTags = value;
            OnPropertyChanged(nameof(_unselectedTags));
        }
    }

    public void AddFile(AccountTransactionFile file)
    {
        _files.Add(file);
        _currentTansactionVersion.Files.Add(file);
        OnPropertyChanged(nameof(Files));
    }

    public void AddTag(Tag tag)
    {
        _currentTansactionVersion.Tags.Add(tag);
        _selectedTags.Add(tag);
        _unselectedTags.Remove(tag);
        OnPropertyChanged(nameof(SelectedTags));
        OnPropertyChanged(nameof(UnselectedTags));
    }

    public async Task CloseDatabaseAsync()
    {
        await AppService.CloseFileAsync();
    }

    public void CreateNewTransaction(Enums.TransactionTypeEnum transactionType = Enums.TransactionTypeEnum.Debit)
    {
        _selectedTags = [];
        _unselectedTags = [];
        _isNew = true;
        _files = new();
        CurrentTransaction = new AccountTransaction
        {
            AccountId = LoadedAccount.Id,
            TransactionType = transactionType,
            Tags = new(),
            Files = new(),
        };

        _previousTransactionVersion = CurrentTransaction.DeepClone();

        OnPropertyChanged(null);
    }

    public async Task Initialize()
    {
        AppService.Initialize();
        await AppService.LoadDatabaseAsync(null);
        LoadedAccount = AppService.Account;
        if (DefaultSearchDayCount == "Custom")
        {
            TransactionStartDate = DefaultSearchDayCustomStart;
            TransactionEndDate = DefaultSearchDayCustomEnd;
        }
        else
        {
            if (DefaultSearchDayCount == "30 Days") TransactionStartDate = DateTime.UtcNow.AddDays(-30);
            else if (DefaultSearchDayCount == "45 Days") TransactionStartDate = DateTime.UtcNow.AddDays(-45);
            else if (DefaultSearchDayCount == "60 Days") TransactionStartDate = DateTime.UtcNow.AddDays(-60);
            else if (DefaultSearchDayCount == "90 Days") TransactionStartDate = DateTime.UtcNow.AddDays(-90);
            else
            {
                Trace.WriteLine($"Error parsing app.config's key 'DefaultSearchDayCount'. The value we got was: {DefaultSearchDayCount}. We are going to re-assign to 45 Days.");
                AppService.DefaultSearchDayCount = "45 Days";
                TransactionStartDate = DateTime.UtcNow.AddDays(-45);
            }
            TransactionEndDate = DateTime.UtcNow;
        }
    }
    public async Task LoadAccount(Guid? id)
    {
        if(id != null) LoadedAccount = await AppService.LoadAccountAsync(id.Value);
        Transactions = await AppService.GetAccountTransactionsByDateRangeAsync(LoadedAccount.Id, TransactionStartDate, TransactionEndDate);
        CreateNewTransaction();

    }

    public async Task LoadTransaction(AccountTransaction transaction)
    {
        _selectedTags = [];
        _unselectedTags = [];
        _isNew = false;
        _files = [.. transaction.Files];

        CurrentTransaction = transaction;
        OnPropertyChanged(null);
    }

    public async Task<AccountTransaction> MarkTransactionAsClearedAsync(AccountTransaction transaction)
    {
        return await AppService.MarkTransactionAsClearedAsync(transaction);
    }

    public async Task<AccountTransaction> MarkTransactionAsPendingAsync(AccountTransaction transaction)
    {
        return await AppService.MarkTransactionAsPendingAsync(transaction);
    }

    public void ModifyFile(AccountTransactionFile file)
    {
        var fileToEdit = Files.Where(x => x.Id == file.Id).ToList();
        fileToEdit[0] = file;

        var secondFileToEdit = _currentTansactionVersion.Files.Where(x => x.Id == file.Id).Single();
        secondFileToEdit = file;
        OnPropertyChanged(nameof(Files));
        PropertyFilesChanged();
    }
    public void PropertyFilesChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Files)));
        HasChangedFromOriginal?.Invoke(this, IsChanged);
    }

    public void PropertySelectedTagsChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(SelectedTags)));
        HasChangedFromOriginal?.Invoke(this, IsChanged);
        _currentTansactionVersion.Tags = _selectedTags.ToList();
    }

    public void PropertyUnselectedTagsChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(UnselectedTags)));
        HasChangedFromOriginal?.Invoke(this, IsChanged);
    }

    public async Task RecalculateAccountAsync()
    {
        await AppService.RecalculateAccountAsync(LoadedAccount);
    }

    public void RemoveFile(AccountTransactionFile file)
    {
        _files.Remove(file);
        _currentTansactionVersion.Files.Remove(file);
        OnPropertyChanged(nameof(Files));
    }

    public void RemoveTag(Tag tag)
    {
        _currentTansactionVersion.Tags.Remove(tag);
        _selectedTags.Remove(tag);
        _unselectedTags.Add(tag);
        OnPropertyChanged(nameof(SelectedTags));
        OnPropertyChanged(nameof(UnselectedTags));
    }

    public async Task<Tuple<Account, AccountTransaction>> SaveLoadedTransaction()
    {
        var transaction = await AppService.SaveTransactionAsync(_currentTansactionVersion, _isNew, _previousTransactionVersion);
        _previousTransactionVersion = _currentTansactionVersion.DeepClone();
        _isNew = false;
        OnPropertyChanged(null);

        return transaction;
    }

    public override string ToString()
    {
        return $"Name: {Name} | Amount: {Amount} | ID: {Id}";
    }
    protected void OnPropertyChanged(string? propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        HasChangedFromOriginal?.Invoke(this, IsChanged);
    }
}
