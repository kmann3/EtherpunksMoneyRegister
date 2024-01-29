using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WPFMannsMoneyRegister.Data.Entities;
using System.Collections.ObjectModel;
using System.Text.Json.Serialization;
using static WPFMannsMoneyRegister.Controls.TransactionItemViewModel;
using WPFMannsMoneyRegister.Data;
using WPFMannsMoneyRegister.Data.Entities.Base;
using Microsoft.VisualBasic;
using System.Diagnostics;
using System.Collections.Specialized;
using System.Windows.Documents;

namespace WPFMannsMoneyRegister.Controls;
public class TransactionItemViewModel : INotifyPropertyChanged
{
    private List<Category> _allCategories = new();
    private AccountTransaction previousTransactionVersion = new();
    private AccountTransaction currentTransactionVersion = new();

    public event EventHandler<bool> HasChanged;
    public event PropertyChangedEventHandler PropertyChanged;

    /// <summary>
    /// Fires when a property changes.
    /// Returns false if there are NO changes to the loaded transaction.
    /// Returns true if there ARE changes to the loaded transaction.
    /// This is used for the save button to enable/disable.
    /// </summary>
    protected virtual void OnHasChanged()
    {
        HasChanged?.Invoke(this, !previousTransactionVersion.DeepEquals(currentTransactionVersion));
    }
    /// <summary>
    /// Notifies objects registered to receive this event that a property value has changed.
    /// </summary>
    /// <param name="propertyName">The name of the property that was changed.</param>
    protected virtual void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

    public void PropertyFilesChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Files)));
    }

    public void PropertySelectedCategoriesChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(SelectedCategories)));
        currentTransactionVersion.Categories = _selectedCategories.ToList();
    }

    public void PropertyUnselectedCategoriesChanged()
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(UnselectedCategories)));
    }

    public async Task LoadAccountTransaction(Guid id)
    {
        currentTransactionVersion = await AddDbService.GetTransactionAsync(id);
        previousTransactionVersion = currentTransactionVersion.DeepClone();
        _allCategories = await AddDbService.GetAllCategoriesAsync();
        _selectedCategories = [];
        _unselectedCategories = [];

        _selectedCategories.CollectionChanged += _selectedCategories_CollectionChanged;
        _unselectedCategories.CollectionChanged += _unselectedCategories_CollectionChanged;
    }

    private async Task SaveLoadedTransaction()
    {
        await AddDbService.UpdateTransaction(currentTransactionVersion);
    }

    private void _unselectedCategories_CollectionChanged(object? sender, NotifyCollectionChangedEventArgs e)
    {
        Trace.WriteLine("UNSELECTED CHANGE");
        if (e.NewItems != null)
        {
            foreach (var x in e.NewItems)
            {
                // do something
                Trace.WriteLine($"New item: {(x as Category).Name}");
            }
        }

        if (e.OldItems != null)
        {
            foreach (var y in e.OldItems)
            {
                //do something
                Trace.WriteLine($"Old item: {(y as Category).Name}");
            }
        }
        if (e.Action == NotifyCollectionChangedAction.Remove)
        {
            //do something
            Trace.WriteLine($"Removed: ");
        }
        else if (e.Action == NotifyCollectionChangedAction.Add)
        {
            Trace.WriteLine($"Add: ");
        }
    }

    private void _selectedCategories_CollectionChanged(object? sender, NotifyCollectionChangedEventArgs e)
    {
        Trace.WriteLine("SELECTED CHANGE");
        if (e.NewItems != null)
        {
            foreach (var x in e.NewItems)
            {
                // do something
                Trace.WriteLine($"New item: {(x as Category).Name}");
            }
        }

        if (e.OldItems != null)
        {
            foreach (var y in e.OldItems)
            {
                //do something
                Trace.WriteLine($"Old item: {(y as Category).Name}");
            }
        }
        if (e.Action == NotifyCollectionChangedAction.Remove)
        {
            //do something
            Trace.WriteLine($"Removed: ");
        }
        else if (e.Action == NotifyCollectionChangedAction.Add)
        {
            Trace.WriteLine($"Add: ");
        }
    }

    public override string ToString()
    {
        return $"Name: {Name} | Amount: {Amount} | ID: {Id}";
    }


    public bool IsChanged
    {
        get
        {
            return !previousTransactionVersion.DeepEquals(currentTransactionVersion);
        }
    }

    public Guid AccountId
    {
        get => currentTransactionVersion.AccountId;
        set
        {
            if (currentTransactionVersion.AccountId == value) return;
            currentTransactionVersion.AccountId = value;
            OnPropertyChanged(nameof(AccountId));
        }
    }

    public decimal Amount
    {
        get => currentTransactionVersion.Amount;
        set
        {
            if(currentTransactionVersion.Amount == value) return;
            currentTransactionVersion.Amount = value;
            OnPropertyChanged(nameof(Amount));
        }
    }

    public string BankTransactionText
    {
        get => currentTransactionVersion.BankTransactionText;
        set
        {
            if (currentTransactionVersion.BankTransactionText == value) return;
            currentTransactionVersion.BankTransactionText = value;
            OnPropertyChanged(nameof(BankTransactionText));
        }
    }

    public string ConfirmationNumber
    {
        get => currentTransactionVersion.ConfirmationNumber;
        set
        {
            if (currentTransactionVersion.ConfirmationNumber == value) return;
            currentTransactionVersion.ConfirmationNumber = value;
            OnPropertyChanged(nameof(ConfirmationNumber));
        }
    }

    public DateTime CreatedOn
    {
        get => currentTransactionVersion.CreatedOnLocalTime;
    }

    public DateTime? DueDate
    {
        get => currentTransactionVersion.DueDate;
        set
        {
            if (currentTransactionVersion.DueDate == value) return;
            currentTransactionVersion.DueDate = value;
            OnPropertyChanged(nameof(DueDate));
        }
    }

    public List<TransactionFile> Files
    {
        get => currentTransactionVersion.Files;
        set
        {
            if (currentTransactionVersion.Files == value) return;
            currentTransactionVersion.Files = value;
            OnPropertyChanged(nameof(Files));
        }
    }

    public Guid Id
    {
        get => currentTransactionVersion.Id;
    }

    public string Name
    {
        get => currentTransactionVersion.Name;
        set
        {
            if (currentTransactionVersion.Name == value) return;
            currentTransactionVersion.Name = value;
            OnPropertyChanged(nameof(Name));
        }
    }

    public string Notes
    {
        get => currentTransactionVersion.Notes;
        set
        {
            if (currentTransactionVersion.Notes == value)  return;
            currentTransactionVersion.Notes = value;
            OnPropertyChanged(nameof(Notes));
        }
    }

    private ObservableCollection<Category> _selectedCategories = [];

    public ObservableCollection<Category> SelectedCategories
    {
        get
        {
            if (_selectedCategories == null || _selectedCategories.Count == 0)
            {
                _selectedCategories = [.. currentTransactionVersion.Categories.OrderBy(x => x.Name)];
            }

            return _selectedCategories;
        }
        set
        {
            _selectedCategories = value;
            OnPropertyChanged(nameof(SelectedCategories));
        }
    }

    public DateTime? TransactionCleared
    {
        get => currentTransactionVersion.TransactionClearedLocalTime;
        set
        {
            if (currentTransactionVersion.TransactionClearedLocalTime == value) return;
            currentTransactionVersion.TransactionClearedLocalTime = value;
            OnPropertyChanged(nameof(TransactionCleared));
        }
    }
    public DateTime? TransactionPending
    {
        get => currentTransactionVersion.TransactionPendingLocalTime;
        set
        {
            if (currentTransactionVersion.TransactionPendingLocalTime == value) return;
            currentTransactionVersion.TransactionPendingLocalTime = value;
            OnPropertyChanged(nameof(TransactionPending));
        }
    }

    public Enums.TransactionTypeEnum TransactionType
    {
        get => currentTransactionVersion.TransactionType;
        set
        {
            if (currentTransactionVersion.TransactionType == value) return;
            currentTransactionVersion.TransactionType = value;
            OnPropertyChanged(nameof(TransactionType));
        }
    }

    private ObservableCollection<Category> _unselectedCategories = [];
    public ObservableCollection<Category> UnselectedCategories
    {
        get
        {
            if (_unselectedCategories == null || _unselectedCategories.Count == 0)
            {
                _unselectedCategories = new();
                foreach (var cat in _allCategories.OrderBy(x => x.Name))
                {
                    if (!currentTransactionVersion.Categories.Any(x => x.Id == cat.Id))
                    {
                        _unselectedCategories.Add(cat);
                    }
                }
            }
            return _unselectedCategories;
        }
        set
        {
            _unselectedCategories = value;
            OnPropertyChanged(nameof(UnselectedCategories));
        }
    }

    private void HandleChangeInCategories(object sender, NotifyCollectionChangedEventArgs e)
    {
        Trace.WriteLine("Something?");
    }
}
