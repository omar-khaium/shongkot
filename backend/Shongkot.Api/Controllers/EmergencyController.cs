using Microsoft.AspNetCore.Mvc;
using Shongkot.Domain.Entities;

namespace Shongkot.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class EmergencyController : ControllerBase
{
    private readonly ILogger<EmergencyController> _logger;
    private static readonly List<Emergency> _emergencies = new();

    public EmergencyController(ILogger<EmergencyController> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Trigger a new emergency alert
    /// </summary>
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public ActionResult<Emergency> TriggerEmergency([FromBody] CreateEmergencyRequest request)
    {
        _logger.LogInformation("Emergency triggered: Type={Type}, Location=({Lat},{Lng})", 
            request.Type, request.Latitude, request.Longitude);

        var emergency = new Emergency
        {
            Id = Guid.NewGuid(),
            UserId = request.UserId,
            Type = request.Type,
            Status = EmergencyStatus.Active,
            Latitude = request.Latitude,
            Longitude = request.Longitude,
            Address = request.Address,
            Timestamp = DateTime.UtcNow,
            Notes = request.Notes,
            CreatedAt = DateTime.UtcNow
        };

        _emergencies.Add(emergency);

        // In a real application, this would:
        // - Save to database
        // - Notify emergency contacts via SMS/Push
        // - Alert nearby responders
        // - Send to emergency services if configured

        return CreatedAtAction(nameof(GetEmergency), new { id = emergency.Id }, emergency);
    }

    /// <summary>
    /// Get emergency details by ID
    /// </summary>
    [HttpGet("{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<Emergency> GetEmergency(Guid id)
    {
        var emergency = _emergencies.FirstOrDefault(e => e.Id == id);
        if (emergency == null)
        {
            return NotFound();
        }

        return Ok(emergency);
    }

    /// <summary>
    /// Get all emergencies for a user
    /// </summary>
    [HttpGet("user/{userId}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public ActionResult<IEnumerable<Emergency>> GetUserEmergencies(string userId)
    {
        var emergencies = _emergencies
            .Where(e => e.UserId == userId)
            .OrderByDescending(e => e.Timestamp)
            .ToList();

        return Ok(emergencies);
    }

    /// <summary>
    /// Update emergency status
    /// </summary>
    [HttpPatch("{id}/status")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<Emergency> UpdateStatus(Guid id, [FromBody] UpdateStatusRequest request)
    {
        var emergency = _emergencies.FirstOrDefault(e => e.Id == id);
        if (emergency == null)
        {
            return NotFound();
        }

        emergency.Status = request.Status;
        emergency.UpdatedAt = DateTime.UtcNow;

        _logger.LogInformation("Emergency {Id} status updated to {Status}", id, request.Status);

        return Ok(emergency);
    }

    /// <summary>
    /// Cancel an emergency
    /// </summary>
    [HttpPost("{id}/cancel")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<Emergency> CancelEmergency(Guid id)
    {
        var emergency = _emergencies.FirstOrDefault(e => e.Id == id);
        if (emergency == null)
        {
            return NotFound();
        }

        emergency.Status = EmergencyStatus.Cancelled;
        emergency.UpdatedAt = DateTime.UtcNow;

        _logger.LogInformation("Emergency {Id} cancelled", id);

        return Ok(emergency);
    }

    /// <summary>
    /// Find nearby responders
    /// </summary>
    [HttpPost("find-responders")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public ActionResult<IEnumerable<Responder>> FindNearbyResponders([FromBody] LocationRequest request)
    {
        // Mock responders for now
        var responders = new List<Responder>
        {
            new Responder
            {
                Id = Guid.NewGuid(),
                Name = "Central Police Station",
                Type = ResponderType.Police,
                Latitude = request.Latitude + 0.01,
                Longitude = request.Longitude + 0.01,
                PhoneNumber = "999",
                IsAvailable = true,
                LastActive = DateTime.UtcNow
            },
            new Responder
            {
                Id = Guid.NewGuid(),
                Name = "City Hospital Ambulance",
                Type = ResponderType.Ambulance,
                Latitude = request.Latitude - 0.01,
                Longitude = request.Longitude + 0.01,
                PhoneNumber = "101",
                IsAvailable = true,
                LastActive = DateTime.UtcNow
            }
        };

        return Ok(responders);
    }
}

public record CreateEmergencyRequest(
    string UserId,
    EmergencyType Type,
    double Latitude,
    double Longitude,
    string? Address,
    string? Notes
);

public record UpdateStatusRequest(EmergencyStatus Status);

public record LocationRequest(double Latitude, double Longitude);
