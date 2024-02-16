using MannsMoneyRegister.Data;
using MannsMoneyRegister.Data.Entities;
using MannsMoneyRegister.Data.Entities.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace MannsMoneyRegister;

public class MainWindowViewModel : INotifyPropertyChanged
{
    private AccountTransaction _currentTansactionVersion = new();
    private bool _isNew = false;
    private AccountTransaction _previousTransactionVersion = new();
    private ObservableCollection<Tag> _selectedTags = [];
    private ObservableCollection<Tag> _unselectedTags = [];
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
            _previousTransactionVersion = value.DeepClone();
        }
    }

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

    public List<AccountTransactionFile> Files
    {
        get => _currentTansactionVersion.Files;
        set
        {
            if (_currentTansactionVersion.Files == value) return;
            _currentTansactionVersion.Files = value;
            OnPropertyChanged(nameof(Files));
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
        throw new NotImplementedException();
    }

    public void AddTag(Tag tag)
    {
        _currentTansactionVersion.Tags.Add(tag);
        _selectedTags.Add(tag);
        _unselectedTags.Remove(tag);
        OnPropertyChanged(nameof(SelectedTags));
        OnPropertyChanged(nameof(UnselectedTags));
    }

    public void CreateNewTransaction(Guid accountId, Enums.TransactionTypeEnum transactionType = Enums.TransactionTypeEnum.Debit)
    {
        _selectedTags = [];
        _unselectedTags = [];
        _isNew = true;
        CurrentTransaction = new AccountTransaction
        {
            AccountId = accountId,
            TransactionType = transactionType,
            Tags = new(),
            Files = new(),
        };

        _previousTransactionVersion = CurrentTransaction.DeepClone();

        OnPropertyChanged(null);
    }

    public async Task LoadTransaction(AccountTransaction transaction)
    {
        _selectedTags = [];
        _unselectedTags = [];
        _isNew = false;
        CurrentTransaction = transaction;
        OnPropertyChanged(null);
    }

    public void PropertyFilesChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Files)));
    }

    public void PropertySelectedTagsChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(SelectedTags)));
        _currentTansactionVersion.Tags = _selectedTags.ToList();
    }

    public void PropertyUnselectedTagsChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(UnselectedTags)));
    }

    public void RemoveFile(AccountTransactionFile file)
    {
        throw new NotImplementedException();
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
        var foo = await AppService.SaveTransactionAsync(_currentTansactionVersion, _isNew, _previousTransactionVersion);
        _previousTransactionVersion = _currentTansactionVersion.DeepClone();
        _isNew = false;
        OnPropertyChanged(null);

        return foo;
    }

    public override string ToString()
    {
        return $"Name: {Name} | Amount: {Amount} | ID: {Id}";
    }

    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}