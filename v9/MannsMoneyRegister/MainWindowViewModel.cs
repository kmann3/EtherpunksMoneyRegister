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
    public List<AccountTransaction> Transactions { get; set; } = new();
    public AccountTransaction CurrentTransaction {
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
    
    private AccountTransaction _currentTansactionVersion = new();
    private AccountTransaction _previousTransactionVersion = new();

    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
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
    public void CreateNewTransaction(Guid accountId, Enums.TransactionTypeEnum transactionType = Enums.TransactionTypeEnum.Debit)
    {
        CurrentTransaction = new AccountTransaction
        {
            AccountId = accountId,
            TransactionType = transactionType,
        };

        _previousTransactionVersion = CurrentTransaction.DeepClone();
        _selectedTags = [];
        _unselectedTags = [];
        _isNew = true;

        OnPropertyChanged(null);

        //_selectedTags.CollectionChanged += SelectedCategories_CollectionChanged;
        //_unselectedTags.CollectionChanged += UnselectedCategories_CollectionChanged;
    }

    public async Task LoadTransaction(AccountTransaction transaction)
    {
        CurrentTransaction = transaction;
        OnPropertyChanged(null);
    }

    public async Task SaveLoadedTransaction()
    {
        await AppService.SaveTransactionAsync(_currentTansactionVersion, _isNew, _previousTransactionVersion);
        _previousTransactionVersion = _currentTansactionVersion.DeepClone();
        _isNew = false;
    }

    public event PropertyChangedEventHandler? PropertyChanged;

    //private void UnselectedCategories_CollectionChanged(object? sender, NotifyCollectionChangedEventArgs e)
    //{
    //    Trace.WriteLine("UNSELECTED CHANGE");
    //    if (e.NewItems != null)
    //    {
    //        foreach (object? x in e.NewItems)
    //        {
    //            // do something
    //            Trace.WriteLine($"New item: {(x as Category).Name}");
    //        }
    //    }

    //    if (e.OldItems != null)
    //    {
    //        foreach (object? y in e.OldItems)
    //        {
    //            //do something
    //            Trace.WriteLine($"Old item: {(y as Category).Name}");
    //        }
    //    }
    //    if (e.Action == NotifyCollectionChangedAction.Remove)
    //    {
    //        //do something
    //        Trace.WriteLine($"Removed: ");
    //    }
    //    else if (e.Action == NotifyCollectionChangedAction.Add)
    //    {
    //        Trace.WriteLine($"Add: ");
    //    }
    //}

    //private void SelectedCategories_CollectionChanged(object? sender, NotifyCollectionChangedEventArgs e)
    //{
    //    Trace.WriteLine("SELECTED CHANGE");
    //    if (e.NewItems != null)
    //    {
    //        foreach (object? x in e.NewItems)
    //        {
    //            // do something
    //            Trace.WriteLine($"New item: {(x as Category).Name}");
    //        }
    //    }

    //    if (e.OldItems != null)
    //    {
    //        foreach (object? y in e.OldItems)
    //        {
    //            //do something
    //            Trace.WriteLine($"Old item: {(y as Category).Name}");
    //        }
    //    }
    //    if (e.Action == NotifyCollectionChangedAction.Remove)
    //    {
    //        //do something
    //        Trace.WriteLine($"Removed: ");
    //    }
    //    else if (e.Action == NotifyCollectionChangedAction.Add)
    //    {
    //        Trace.WriteLine($"Add: ");
    //    }
    //}

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

    private bool _isNew = false;
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

    private ObservableCollection<Tag> _selectedTags = [];

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

    private ObservableCollection<Tag> _unselectedTags = [];
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

    public override string ToString()
    {
        return $"Name: {Name} | Amount: {Amount} | ID: {Id}";
    }
}
