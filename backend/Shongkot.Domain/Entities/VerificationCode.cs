namespace Shongkot.Domain.Entities;

public class VerificationCode
{
    public Guid Id { get; set; }
    public string Identifier { get; set; } = string.Empty; // Email or Phone
    public VerificationType Type { get; set; }
    public string Code { get; set; } = string.Empty;
    public DateTime ExpiresAt { get; set; }
    public bool IsUsed { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UsedAt { get; set; }
}

public enum VerificationType
{
    Email,
    Phone
}
