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

namespace WPFMannsMoneyRegister.Controls;
public class TransactionItemViewModel : INotifyPropertyChanged
{
    private AccountTransaction previousTransactionVersion = new();
    private AccountTransaction currentTransactionVersion = new();
    public TransactionItemViewModel()
    {
    }


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

    public async Task LoadAccountTransaction(Guid id)
    {
        currentTransactionVersion = await ServiceModel.GetTransactionAsync(id);
        previousTransactionVersion = currentTransactionVersion.DeepClone();
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
        get
        {
            return currentTransactionVersion.AccountId;
        }
        set
        {
            currentTransactionVersion.AccountId = value;
            OnPropertyChanged(nameof(AccountId));
        }
    }

    public decimal Amount
    {
        get
        {
            return currentTransactionVersion.Amount;
        }

        set
        {
            if(currentTransactionVersion.Amount == value) return;
            currentTransactionVersion.Amount = value;
            OnPropertyChanged(nameof(Amount));
        }
    }

    public List<Category> Categories
    {
        get
        {
            return currentTransactionVersion.Categories;
        }
        set
        {
            currentTransactionVersion.Categories = value;
            OnPropertyChanged(nameof(Categories));
        }
    }

    public DateTime CreatedOn
    {
        get
        {
            return currentTransactionVersion.CreatedOnLocalTime;
        }
    }

    public List<TransactionFile> Files
    {
        get
        {
            return currentTransactionVersion.Files;
        }
        set
        {
            currentTransactionVersion.Files = value;
            OnPropertyChanged(nameof(Files));
        }
    }

    public Guid Id
    {
        get
        {
            return currentTransactionVersion.Id;
        }
    }

    public string Name
    {
        get
        {
            return currentTransactionVersion.Name;
        }
        set
        {
            if (currentTransactionVersion.Name == value) return;
            currentTransactionVersion.Name = value;
            OnPropertyChanged(nameof(Name));
        }
    }

    public Enums.TransactionTypeEnum TransactionType
    {
        get
        {
            return currentTransactionVersion.TransactionType;
        }
        set
        {
            currentTransactionVersion.TransactionType = value;
            OnPropertyChanged(nameof(TransactionType));
        }
    }
}
