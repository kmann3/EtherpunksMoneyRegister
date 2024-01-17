﻿using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace WPFMannsMoneyRegister.Data.Entities.Base;

/// <summary>
/// Table base that nearly all tables should inherit.
/// File prefixed with zz to sink to the bottom.
/// </summary>
/// <typeparam name="T"></typeparam>
public abstract class BasicTable<T> : IEntityTypeConfiguration<T>
    where T : class
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.None)]
    [Column(Order = 1)]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    [StringLength(255)]
    [Column(Order = 2)]
    public string Name { get; set; } = string.Empty;

    [Required]
    public DateTime CreatedOnUTC { get; set; } = DateTime.UtcNow;

    public override string ToString()
    {
        return $"Name: {Name} | ID: {Id}";
    }

    public abstract void Configure(EntityTypeBuilder<T> modelBuilder);

    public void Configure(ModelBuilder modelBuilder)
    {
        Configure(modelBuilder.Entity<T>());
    }
}