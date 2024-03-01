using MannsMoneyRegister.Data.Entities.Base;
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
using System.Xml.Linq;
using System.Diagnostics;

namespace MannsMoneyRegister.Data.Entities;

public class AccountTransaction : BasicTable<AccountTransaction>, IEntityTypeConfiguration<AccountTransaction>
{
    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Amount { get; set; } = 0M;

    [JsonIgnore]
    public Account Account { get; set; }
    public Guid AccountId { get; set; }
    public Enums.TransactionTypeEnum TransactionType { get; set; }
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
    public List<Link_Tag_Transaction> Link_Tag_Transactions { get; } = [];
    [NotMapped]
    [JsonIgnore]
    public string TagCompositeString
    {
        get
        {
            return String.Join(", ", Tags.Select(x => x.Name));
        }
    }
    [JsonIgnore]
    public List<Tag> Tags { get; set; } = [];
    [JsonIgnore]
    [NotMapped]
    public int FileCount
    {
        get
        {
            return Files == null ? 0 : Files.Count;
        }
    }

    [JsonIgnore]
    public List<AccountTransactionFile> Files { get; set; } = new();
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
            Enums.TransactionTypeEnum.Credit => Math.Abs(Amount),
            Enums.TransactionTypeEnum.Debit => -Math.Abs(Amount),
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
        AccountTransaction returnTransaction = new()
        {
            //returnTransaction.Account
            AccountId = AccountId,
            Amount = Amount,
            Balance = Balance,
            //returnTransaction.Categories
            ConfirmationNumber = ConfirmationNumber,
            CreatedOnUTC = CreatedOnUTC,
            DueDate = DueDate
        };

        returnTransaction.Files = new();
        foreach (AccountTransactionFile file in Files)
        {
            //returnTransaction.Files
            AccountTransactionFile newFile = new()
            {
                ContentType = file.ContentType,
                CreatedOnUTC = file.CreatedOnUTC,
                Filename = file.Filename,
                Id = file.Id,
                Name = file.Name,
                Notes = file.Notes,
                Data = file.Data.ToArray()
            };

            returnTransaction.Files.Add(newFile);
        }

        returnTransaction.Id = Id;
        foreach (Link_Tag_Transaction tagLink in Link_Tag_Transactions)
        {
            Link_Tag_Transaction newLink = new()
            {
                TagId = tagLink.TagId,
                AccountTransactionId = tagLink.AccountTransactionId,
            };
            returnTransaction.Link_Tag_Transactions.Add(newLink);
        }
        foreach(Tag tag in Tags)
        {
            returnTransaction.Tags.Add(tag);
        }
        returnTransaction.Name = Name;
        returnTransaction.Notes = Notes;
        //returnTransaction.RecurringTransaction
        returnTransaction.RecurringTransactionId = RecurringTransactionId;
        returnTransaction.TransactionClearedUTC = TransactionClearedUTC;
        returnTransaction.TransactionPendingUTC = TransactionPendingUTC;
        returnTransaction.TransactionType = TransactionType;

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
        if (obj == null) return false;
        if (obj is not AccountTransaction secondTransaction) return false;

        bool returnVal = true;

        returnVal = returnVal && Guid.Equals(AccountId, secondTransaction.AccountId);
        returnVal = returnVal && Decimal.Equals(Amount, secondTransaction.Amount);
        returnVal = returnVal && Decimal.Equals(Balance, secondTransaction.Balance);
        //returnTransaction.Categories
        returnVal = returnVal && String.Equals(ConfirmationNumber, secondTransaction.ConfirmationNumber, StringComparison.InvariantCulture);
        returnVal = returnVal && DateTime.Equals(CreatedOnUTC, secondTransaction.CreatedOnUTC);
        returnVal = returnVal && DateTime.Equals(DueDate, secondTransaction.DueDate);
        returnVal = returnVal && Files.Count == secondTransaction.Files.Count;
        foreach (AccountTransactionFile file in Files)
        {
            // See if the second file has a matching fileId
            if (!secondTransaction.Files.Any(x => x.Id == file.Id))
            {
                return false;
            }

            var secondFile = secondTransaction.Files.Where(x => x.Id == file.Id).SingleOrDefault();
            if (secondFile == null) return false;
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

        foreach (AccountTransactionFile file in secondTransaction.Files.Except(Files))
        {
            // See if the second file has a matching fileId
            if (!Files.Any(x => x.Id == file.Id))
            {
                return false;
            }

            var secondFile = secondTransaction.Files.Where(x => x.Id == file.Id).SingleOrDefault();
            if (secondFile == null) return false;
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

        returnVal = returnVal && Guid.Equals(Id, secondTransaction.Id);
        returnVal = returnVal && Link_Tag_Transactions.Count == secondTransaction.Link_Tag_Transactions.Count;
        foreach (Link_Tag_Transaction tag in Link_Tag_Transactions)
        {
            foreach (Link_Tag_Transaction secondTag in secondTransaction.Link_Tag_Transactions)
            {
                // There is probably a better way to compare
                returnVal = returnVal && tag.TagId == secondTag.TagId;
                returnVal = returnVal && tag.AccountTransactionId == secondTag.AccountTransactionId;
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