namespace Shongkot.Domain.Entities;

public class Responder
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public ResponderType Type { get; set; }
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string? Address { get; set; }
    public string PhoneNumber { get; set; } = string.Empty;
    public bool IsAvailable { get; set; }
    public DateTime LastActive { get; set; }
    public DateTime CreatedAt { get; set; }
}

public enum ResponderType
{
    Police,
    Ambulance,
    FireService,
    Volunteer,
    Other
}
