using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using WPFMannsMoneyRegister.Data.Entities.Base;
using System.Diagnostics;
using System.ComponentModel;
using System.Collections.ObjectModel;

namespace WPFMannsMoneyRegister.Data.Entities;
/// <summary>
/// Individual transactions for associated accounts.
/// </summary>
public class AccountTransaction : BasicTable<AccountTransaction>, IEntityTypeConfiguration<AccountTransaction>, INotifyPropertyChanged
{
    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    [JsonIgnore]
    private decimal _amount = 0M;

    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Amount
    {
        get
        {
            return _amount;
        }
        set
        {
            if (_amount != value)
            {
                _amount = value;
                base.OnPropertyChanged(nameof(Amount));
            }
        }
    }

    [JsonIgnore]
    public Account Account { get; set; }
    public Guid AccountId { get; set; }
    public Enums.TransactionType TransactionType { get; set; }
    [Display(Name = "Transaction Pending")]
    public DateTime? TransactionPendingUTC { get; set; } = null;
    [NotMapped]
    [JsonIgnore]
    public DateTime? TransactionPendingLocalTime
    {
        get
        {
            return TransactionPendingUTC.HasValue == true ? TransactionPendingUTC.Value.ToLocalTime() : null;
        }
        set
        {
            TransactionPendingUTC = value.HasValue == true ? value.Value.ToUniversalTime() : null;
        }
    }
    [Display(Name = "Transaction Cleared")]
    public DateTime? TransactionClearedUTC { get; set; } = null;
    [NotMapped]
    [JsonIgnore]
    public DateTime? TransactionClearedLocalTime
    {
        get
        {
            return TransactionClearedUTC.HasValue == true ? TransactionClearedUTC.Value.ToLocalTime() : null;
        }
        set
        {
            TransactionClearedUTC = value.HasValue == true ? value.Value.ToUniversalTime() : null;
        }
    }

    /// <summary>
    /// Decimal.Parse(value)
    /// Balance = value.ToString("0.00")
    /// </summary>
    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Balance { get; set; } = 0M;
    public string Notes { get; set; } = string.Empty;
    [JsonIgnore]
    public List<Link_Category_Transaction> Link_Category_Transactions { get; } = new List<Link_Category_Transaction>();
    [NotMapped]
    [JsonIgnore]
    public string CategoryString
    {
        get
        {
            return String.Join(", ", Categories.Select(x => x.Name));
        }
    }
    [JsonIgnore]
    public List<Category> Categories { get; set; } = new();
    [JsonIgnore]
    [NotMapped]
    public int FileCount
    {
        get
        {
            return Files.Count;
        }
    }

    [JsonIgnore]
    private ObservableCollection<TransactionFile> _files = new();

    [JsonIgnore]
    public ObservableCollection<TransactionFile> Files
    {
        get
        {
            return _files;
        }
        set
        {
            if(_files != value)
            {
                _files = value;
                OnPropertyChanged(nameof(Files));
            }
        }
    }
    [JsonIgnore]
    public RecurringTransaction? RecurringTransaction { get; set; }
    public Guid? RecurringTransactionId { get; set; }
    public DateTime? DueDate { get; set; } = null;
    public string ConfirmationNumber { get; set; } = string.Empty;
    /// <summary>
    /// This is the literal bank line - the one that's not shortened.
    /// Example: CA 408 536 6000 ADOBE / Withdrawal @ CA 408 536 6000 ADOBE *PHOTOGPHY PUSADOBE *PHOTOGPH Trace #70108
    /// </summary>
    public string BankTransactionText { get; set; } = string.Empty;

    public override void Configure(EntityTypeBuilder<AccountTransaction> builder)
    {
    }

    public void VerifySignage()
    {
        Amount = TransactionType switch
        {
            Enums.TransactionType.Credit => Math.Abs(Amount),
            Enums.TransactionType.Debit => -Math.Abs(Amount),
            _ => throw new Exception($"Unknown case: {TransactionType}"),
        };
    }

    /// <summary>
    /// For the deep clone we ignore the following:
    /// Account (but maintain AccountId)
    /// Categories (but maintain the links for comparisons)
    /// RecurringTransaction (but maintain the RecurringTransactionId)
    /// </summary>
    /// <returns></returns>
    public AccountTransaction DeepClone()
    {
        AccountTransaction returnTransaction = new();
        //returnTransaction.Account
        returnTransaction.AccountId = this.AccountId;
        returnTransaction.Amount = this.Amount;
        returnTransaction.Balance = this.Balance;
        //returnTransaction.Categories
        returnTransaction.ConfirmationNumber = this.ConfirmationNumber;
        returnTransaction.CreatedOnUTC = this.CreatedOnUTC;
        returnTransaction.DueDate = this.DueDate;
        
        foreach(var file in returnTransaction.Files)
        {
            //returnTransaction.Files
            TransactionFile newFile = new()
            {
                ContentType = file.ContentType,
                CreatedOnUTC = file.CreatedOnUTC,
                Filename = file.Filename,
                Id = file.Id,
                Name = file.Name,
                Notes = file.Notes,
            };
            file.Data.CopyTo(newFile.Data, 0);

            returnTransaction.Files.Add(newFile);
        }
        returnTransaction.Id = this.Id;
        foreach(var catLink in returnTransaction.Link_Category_Transactions)
        {
            Link_Category_Transaction newLink = new()
            {
                CategoryId = catLink.CategoryId,
                AccountTransactionId = catLink.AccountTransactionId,
            };
            returnTransaction.Link_Category_Transactions.Add(newLink);
        }
        returnTransaction.Name = this.Name;
        returnTransaction.Notes = this.Notes;
        //returnTransaction.RecurringTransaction
        returnTransaction.RecurringTransactionId = this.RecurringTransactionId;
        returnTransaction.TransactionClearedUTC = this.TransactionClearedUTC;
        returnTransaction.TransactionPendingUTC = this.TransactionPendingUTC;
        returnTransaction.TransactionType = this.TransactionType;

        return returnTransaction;
    }

    /// <summary>
    /// Compares two transaction to see if they are the same.
    /// If any are null then it is assumed they are not the same.
    /// The usual use of this is to see if the transaction has changed since it was opened to determine if we need to save or not.
    /// This function is different because it also compares the data for files - which might be large. The problem here is because Equals is used for sorting and other things - it's ran frequently - something we don't need when handling large byte[]'s for file data. Could get nasty real quick.
    /// </summary>
    /// <param name="obj"></param>
    /// <returns></returns>
    public bool DeepEquals(object? obj)
    {
        var secondTransaction = obj as AccountTransaction;
        if (obj == null) return false;
        if (secondTransaction == null) return false;    

        bool returnVal = true;

        returnVal = returnVal && Guid.Equals(AccountId, secondTransaction.AccountId);
        returnVal = returnVal && Decimal.Equals(Amount, secondTransaction.Amount);
        returnVal = returnVal && Decimal.Equals(Balance, secondTransaction.Balance);
        //returnTransaction.Categories
        returnVal = returnVal && String.Equals(ConfirmationNumber, secondTransaction.ConfirmationNumber, StringComparison.InvariantCulture);
        returnVal = returnVal && DateTime.Equals(CreatedOnUTC, secondTransaction.CreatedOnUTC);
        returnVal = returnVal && DateTime.Equals(DueDate, secondTransaction.DueDate);
        returnVal = returnVal && Files.Count == secondTransaction.Files.Count;
        foreach (var file in Files)
        {
            foreach (var secondFile in secondTransaction.Files)
            {
                // Compare the files.
                // There is probably a better way to compare
                returnVal = returnVal && String.Equals(file.ContentType, secondFile.ContentType, StringComparison.InvariantCulture);
                returnVal = returnVal && DateTime.Equals(file.CreatedOnUTC, secondFile.CreatedOnUTC);
                returnVal = returnVal && String.Equals(file.Filename, secondFile.Filename, StringComparison.InvariantCulture);
                returnVal = returnVal && Guid.Equals(file.Id, secondFile.Id);
                returnVal = returnVal && String.Equals(file.Name, secondFile.Name, StringComparison.InvariantCulture);
                returnVal = returnVal && String.Equals(file.Notes, secondFile.Notes, StringComparison.InvariantCulture);
                returnVal = returnVal && file.Data.SequenceEqual(secondFile.Data);
            }
        }
        returnVal = returnVal && Guid.Equals(Id, secondTransaction.Id);
        returnVal = returnVal && Link_Category_Transactions.Count == secondTransaction.Link_Category_Transactions.Count;
        foreach(var cat in Link_Category_Transactions)
        {
            foreach(var secondCategory in secondTransaction.Link_Category_Transactions)
            {
                // There is probably a better way to compare
                returnVal = returnVal && cat.CategoryId == secondCategory.CategoryId;
                returnVal = returnVal && cat.AccountTransactionId == secondCategory.AccountTransactionId;
            }
        }
        returnVal = returnVal && String.Equals(Name, secondTransaction.Name, StringComparison.InvariantCulture);
        returnVal = returnVal && String.Equals(Notes, secondTransaction.Notes, StringComparison.InvariantCulture);
        returnVal = returnVal && Guid.Equals(RecurringTransactionId, secondTransaction.RecurringTransactionId);
        returnVal = returnVal && DateTime.Equals(TransactionClearedUTC, secondTransaction.TransactionClearedUTC);
        returnVal = returnVal && DateTime.Equals(TransactionPendingUTC, secondTransaction.TransactionPendingUTC);
        returnVal = returnVal && TransactionType.Equals(secondTransaction.TransactionType);


        return returnVal;
    }
}