namespace Shongkot.Domain.Entities;

public class Emergency
{
    public Guid Id { get; set; }
    public string UserId { get; set; } = string.Empty;
    public EmergencyType Type { get; set; }
    public EmergencyStatus Status { get; set; }
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string? Address { get; set; }
    public DateTime Timestamp { get; set; }
    public List<string> NotifiedContacts { get; set; } = new();
    public List<string> RespondersAlerted { get; set; } = new();
    public string? Notes { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public enum EmergencyType
{
    Medical,
    Accident,
    Fire,
    Assault,
    Other
}

public enum EmergencyStatus
{
    Active,
    Responding,
    Resolved,
    Cancelled
}
