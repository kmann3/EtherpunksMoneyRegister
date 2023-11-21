using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

public class Bill : BasicTable<Bill>, IEntityTypeConfiguration<Bill>
{
    public DateTime? NextDueDate { get; set; } = null;

    [DataType(DataType.Currency)]
    [Precision(18, 2)]
    public decimal Amount { get; set; } = 0M;
    public string Notes { get; set; } = string.Empty;
    public List<Category> Categories { get; set; }
    
    public Regularity BillFrequency { get; set; } = Regularity.Unknown;
    public enum Regularity
    {
        Monthly,
        XDays, // Can also calculate this to weekly
        Annually,
        Nonregular,
        Unknown
    }

    public int? FrequencyValue { get; set; } = null;

    [JsonIgnore]
    public BillGroup? BillGroup { get; set; }
    public Guid? BillGroupId { get; set; }

    public override void Configure(EntityTypeBuilder<Bill> builder)
    {
        //builder.HasIndex(k => k.Name).IsUnique(true);
    }    
}
