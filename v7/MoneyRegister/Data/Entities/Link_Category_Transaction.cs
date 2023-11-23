﻿using System.Text.Json.Serialization;

namespace MoneyRegister.Data.Entities;

public class Link_Category_Transaction
{
    public Guid CategoryId { get; set; }
    public Guid TransactionId { get; set; }

    [JsonIgnore]
    public Category Category { get; set; } = null!;
    [JsonIgnore]
    public Transaction Transaction { get; set; } = null!;
}
