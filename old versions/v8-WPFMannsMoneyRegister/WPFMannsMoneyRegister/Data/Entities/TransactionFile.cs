using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Text.Json.Serialization;
using WPFMannsMoneyRegister.Data.Entities.Base;

namespace WPFMannsMoneyRegister.Data.Entities;
/// <summary>
/// The binary data and meta data of a file.
/// </summary>
public class TransactionFile : BasicTable<TransactionFile>, IEntityTypeConfiguration<TransactionFile>
{
    /// <summary>
    /// We ignore the data because we're going to re-create the file itself and zip it.
    /// The Filename will have the Id so it can match accordingly.
    /// </summary>
    public byte[] Data { get; set; } = [];

    [JsonIgnore]
    public AccountTransaction AccountTransaction { get; set; }

    public Guid AccountTransactionId { get; set; }

    public string Filename { get; set; } = string.Empty;
    public string ContentType { get; set; } = string.Empty;
    [JsonIgnore]
    public string Size
    {
        get
        {
            return ByteSizeLib.ByteSize.FromBytes(Data.Length).ToString();
        }
    }

    public string Notes { get; set; } = string.Empty;

    // Consider a lookup for types of files such as bills, contracts, warranties, etc

    public override void Configure(EntityTypeBuilder<TransactionFile> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }

    public TransactionFile DeepClone()
    {
        TransactionFile returnFile = new()
        {
            AccountTransactionId = this.AccountTransactionId,
            ContentType = this.ContentType,
            CreatedOnUTC = this.CreatedOnUTC,
            Filename = this.Filename,
            Id = this.Id,
            Notes = this.Notes,
        };

        this.Data.CopyTo(returnFile.Data, 0);

        return returnFile;
    }

    public bool DeepEquals(object? obj)
    {
        if (obj == null) return false;
        if (obj is not TransactionFile secondTransactionFile) return false;

        bool returnVal = true;

        returnVal = returnVal && Guid.Equals(this.AccountTransactionId, secondTransactionFile.AccountTransactionId);
        returnVal = returnVal && String.Equals(this.ContentType, secondTransactionFile.ContentType);
        returnVal = returnVal && DateTime.Equals(this.CreatedOnUTC, secondTransactionFile.CreatedOnUTC);
        returnVal = returnVal && this.Data.SequenceEqual(secondTransactionFile.Data);
        returnVal = returnVal && String.Equals(this.Filename, secondTransactionFile.Filename);
        returnVal = returnVal && Guid.Equals(this.Id, secondTransactionFile.Id);
        returnVal = returnVal && String.Equals(this.Notes, secondTransactionFile.Notes);


        return returnVal;
    }
}