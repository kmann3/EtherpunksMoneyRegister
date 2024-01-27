using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WPFMannsMoneyRegister.Data.Entities;

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

    public void LoadAccountTransaction(AccountTransaction transaction)
    {
        currentTransactionVersion = transaction;
        previousTransactionVersion = transaction.DeepClone();
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

    public DateTime CreatedOn
    {
        get
        {
            return currentTransactionVersion.CreatedOnLocalTime;
        }
    }
}
