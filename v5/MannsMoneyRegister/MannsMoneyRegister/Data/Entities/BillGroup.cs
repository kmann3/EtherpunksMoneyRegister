using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace MannsMoneyRegister.Data.Entities;

public class BillGroup : BasicTable<BillGroup>, IEntityTypeConfiguration<BillGroup>
{
    [JsonIgnore]
    public List<Bill> Bills { get; set; }

    public override void Configure(EntityTypeBuilder<BillGroup> builder)
    {
        builder.HasIndex(k => k.Name).IsUnique(true);
    }    
}
