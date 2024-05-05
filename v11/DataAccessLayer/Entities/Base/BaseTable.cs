using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace EtherpunksMoneyRegister_DAL.Entities.Base;

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
    [NotMapped]
    [JsonIgnore]
    public DateTime CreatedOnLocalTime
    {
        get
        {
            return CreatedOnUTC.ToLocalTime();
        }
        set
        {
            CreatedOnUTC = value.ToUniversalTime();
        }
    }

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
