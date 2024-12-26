using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MoneyRegister.Data.Entities;

// Add profile data for application users by adding properties to the ApplicationUser class
public class ApplicationUser : IdentityUser, IEntityTypeConfiguration<ApplicationUser>
{
    public string FirstName { get; set; } = string.Empty;

    public string FullNameFirstFirst => FirstName + " " + LastName;

    public string FullNameLastFirst => LastName + ", " + FirstName;

    public bool IsDisabled { get; set; } = false;

    public string LastName { get; set; } = string.Empty;

    public string LocalTimeZone { get; set; } = "Central Standard Time";
    public DateTime CreatedOn { get; set; } = DateTime.UtcNow;

    //[JsonIgnore]
    //public List<Transaction> Transactions { get; set; } = new();

    // CURRENCY?

    public void Configure(EntityTypeBuilder<ApplicationUser> builder)
    {
    }
}