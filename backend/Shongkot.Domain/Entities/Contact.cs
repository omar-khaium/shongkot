namespace Shongkot.Domain.Entities;

public class Contact
{
    public Guid Id { get; set; }
    public string UserId { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public string? Email { get; set; }
    public ContactRelationship Relationship { get; set; }
    public bool IsPrimary { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public enum ContactRelationship
{
    Family,
    Friend,
    Colleague,
    Neighbor,
    Other
}
