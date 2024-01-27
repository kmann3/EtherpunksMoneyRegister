using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Diagnostics;

namespace WPFMannsMoneyRegister.Data.Entities.Base;

/// <summary>
/// Table base that nearly all tables should inherit.
/// File prefixed with zz to sink to the bottom.
/// </summary>
/// <typeparam name="T"></typeparam>
public abstract class BasicTable<T> : IEntityTypeConfiguration<T>, INotifyPropertyChanged
    where T : class
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.None)]
    [Column(Order = 1)]
    public Guid Id { get; set; } = Guid.NewGuid();

    private string _name = string.Empty;
    [Required]
    [StringLength(255)]
    [Column(Order = 2)]
    public string Name
    {
        get
        {
            return _name;
        }
        set
        {
            _name = value;
            OnPropertyChanged(nameof(Name));
        }
    }

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

    public event PropertyChangedEventHandler PropertyChanged;

    /// <summary>
    /// Notifies objects registered to receive this event that a property value has changed.
    /// </summary>
    /// <param name="propertyName">The name of the property that was changed.</param>
    protected virtual void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}