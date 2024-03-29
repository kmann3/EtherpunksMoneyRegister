﻿using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MoneyRegister.Data.Entities.Base;
using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

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
    public Transaction Transaction { get; set; }

    public Guid TransactionId { get; set; }

    public string Filename { get; set; } = string.Empty;
    public string ContentType { get; set; } = string.Empty;

    public string Notes { get; set; } = string.Empty;

    // Consider a lookup for types of files such as bills, contracts, warranties, etc

    public override void Configure(EntityTypeBuilder<TransactionFile> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }
}