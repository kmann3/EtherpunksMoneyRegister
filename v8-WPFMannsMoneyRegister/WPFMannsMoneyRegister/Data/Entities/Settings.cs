using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using WPFMannsMoneyRegister.Data.Entities.Base;
using System.ComponentModel.DataAnnotations;

namespace WPFMannsMoneyRegister.Data.Entities;

public class Settings
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Key]
    [Column(Order = 0)]
    public int Id { get; set; } = -1;

    [Column(Order = 1)]
    public Guid DefaultAccountId { get; set; } = Guid.Empty;

    [Column(Order = 2)]
    public int SearchDayCount { get; set; } = 45;



}