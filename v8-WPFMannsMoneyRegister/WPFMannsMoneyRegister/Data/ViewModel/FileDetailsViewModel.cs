using Microsoft.EntityFrameworkCore.Metadata;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using WPFMannsMoneyRegister.Data.Entities;

namespace WPFMannsMoneyRegister.Data.ViewModel;
public class FileDetailsViewModel
{
    private TransactionFile previousTransactionFileVersion = new();
    private TransactionFile currentTransactionFileVersion = new();

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
        HasChanged?.Invoke(this, !previousTransactionFileVersion.DeepEquals(currentTransactionFileVersion));
    }

    /// <summary>
    /// Notifies objects registered to receive this event that a property value has changed.
    /// </summary>
    /// <param name="propertyName">The name of the property that was changed.</param>
    protected virtual void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

    public async Task CreateNewFile(Guid accountTransactionId)
    {
        _isNew = true;
        throw new NotImplementedException();
    }

    public async Task LoadFile(Guid id)
    {
        throw new NotImplementedException();
    }

    public async Task SaveLoadedFile()
    {
        if (IsNew)
        {

            _isNew = false;
        }
        else
        {

        }

        throw new NotImplementedException();
    }

    public override string ToString()
    {
        return $"Name: {Name} | Filename: {Filename} | Size: {HumanSize} | ID: {Id}";
    }

    public bool IsChanged
    {
        get
        {
            return !previousTransactionFileVersion.DeepEquals(currentTransactionFileVersion);
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

}
