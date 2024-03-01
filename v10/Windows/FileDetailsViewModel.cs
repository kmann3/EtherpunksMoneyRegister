using MannsMoneyRegister.Data.Entities;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MannsMoneyRegister.Windows;
public class FileDetailsViewModel : INotifyPropertyChanged
{
    public event PropertyChangedEventHandler? PropertyChanged;
    public event EventHandler<bool> HasChangedFromOriginal;
    private AccountTransactionFile _currentFile;
    private AccountTransactionFile _previousFile;

    public AccountTransactionFile CurrentFile
    {
        get =>  _currentFile;
    }

    public byte[] Data
    {
        get => _currentFile.Data;
        set
        {
            if(_currentFile.Data == value) return;
            _currentFile.Data = value;
            OnPropertyChanged(nameof(Data));
            OnPropertyChanged(nameof(Size));
        }
    }
    
    public void LoadData(AccountTransactionFile? file)
    {
        if (file == null)
        {
            _currentFile = new();
            _previousFile = _currentFile.DeepClone();
        }
        else
        {
            _currentFile = file;
            _previousFile = file.DeepClone();
        }
    }

    public Guid AccountTransactionId
    {
        get => _currentFile.Id;
    }

    public string Filename
    {
        get => _currentFile.Filename;
        set
        {
            if (_currentFile.Filename == value) return;
            _currentFile.Filename = value;
            OnPropertyChanged(nameof(Filename));
        }
    }
    public string ContentType
    {
        get => _currentFile.ContentType;
        set
        {
            if (_currentFile.ContentType == value) return;
            _currentFile.ContentType = value;
            OnPropertyChanged(nameof(ContentType));
        }
    }
    public bool IsChanged
    {
        get
        {
            return !_previousFile.DeepEquals(_currentFile);
        }
    }
    
    public string Size
    {
        get
        {
            return ByteSizeLib.ByteSize.FromBytes(Data.Length).ToString();
        }
        set { }
    }

    public string Notes
    {
        get => _currentFile.Notes;
        set
        {
            if (_currentFile.Notes == value) return;
            _currentFile.Notes = value;
            OnPropertyChanged(nameof(Notes));
        }
    }

    public string Name
    {
        get => _currentFile.Name;
        set
        {
            if (_currentFile.Name == value) return;
            _currentFile.Name = value;
            OnPropertyChanged(nameof(Name));
        }
    }

    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        HasChangedFromOriginal?.Invoke(this, IsChanged);
    }
}
