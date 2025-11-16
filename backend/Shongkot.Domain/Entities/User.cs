namespace Shongkot.Domain.Entities;

public class User
{
    public Guid Id { get; set; }
    public string? PhoneNumber { get; set; }
    public string? Email { get; set; }
    public bool IsPhoneVerified { get; set; }
    public bool IsEmailVerified { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}
