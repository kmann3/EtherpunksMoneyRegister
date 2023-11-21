using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

public class TransactionFile : BasicTable<TransactionFile>, IEntityTypeConfiguration<TransactionFile>
{
    /// <summary>
    /// We ignore the data because we're going to re-create the file itself and zip it.
    /// The Filename will have the Id so it can match accordingly.
    /// </summary>
    [JsonIgnore]
    public byte[] Data { get; set; }
    [JsonIgnore]
    public Transaction Transaction { get; set; }
    public Guid TransactionId { get; set; }

    public override void Configure(EntityTypeBuilder<TransactionFile> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }    
}
