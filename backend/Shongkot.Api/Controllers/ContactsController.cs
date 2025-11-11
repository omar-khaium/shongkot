using Microsoft.AspNetCore.Mvc;
using Shongkot.Domain.Entities;

namespace Shongkot.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ContactsController : ControllerBase
{
    private readonly ILogger<ContactsController> _logger;
    private static readonly List<Contact> _contacts = new();

    public ContactsController(ILogger<ContactsController> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Get all contacts for a user
    /// </summary>
    [HttpGet("user/{userId}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public ActionResult<IEnumerable<Contact>> GetUserContacts(string userId)
    {
        var contacts = _contacts
            .Where(c => c.UserId == userId)
            .OrderByDescending(c => c.IsPrimary)
            .ThenBy(c => c.Name)
            .ToList();

        return Ok(contacts);
    }

    /// <summary>
    /// Add a new emergency contact
    /// </summary>
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public ActionResult<Contact> AddContact([FromBody] CreateContactRequest request)
    {
        var contact = new Contact
        {
            Id = Guid.NewGuid(),
            UserId = request.UserId,
            Name = request.Name,
            PhoneNumber = request.PhoneNumber,
            Email = request.Email,
            Relationship = request.Relationship,
            IsPrimary = request.IsPrimary,
            CreatedAt = DateTime.UtcNow
        };

        _contacts.Add(contact);

        _logger.LogInformation("Contact added: {Name} for user {UserId}", contact.Name, contact.UserId);

        return CreatedAtAction(nameof(GetContact), new { id = contact.Id }, contact);
    }

    /// <summary>
    /// Get contact by ID
    /// </summary>
    [HttpGet("{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<Contact> GetContact(Guid id)
    {
        var contact = _contacts.FirstOrDefault(c => c.Id == id);
        if (contact == null)
        {
            return NotFound();
        }

        return Ok(contact);
    }

    /// <summary>
    /// Update a contact
    /// </summary>
    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<Contact> UpdateContact(Guid id, [FromBody] UpdateContactRequest request)
    {
        var contact = _contacts.FirstOrDefault(c => c.Id == id);
        if (contact == null)
        {
            return NotFound();
        }

        contact.Name = request.Name;
        contact.PhoneNumber = request.PhoneNumber;
        contact.Email = request.Email;
        contact.Relationship = request.Relationship;
        contact.IsPrimary = request.IsPrimary;
        contact.UpdatedAt = DateTime.UtcNow;

        return Ok(contact);
    }

    /// <summary>
    /// Delete a contact
    /// </summary>
    [HttpDelete("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult DeleteContact(Guid id)
    {
        var contact = _contacts.FirstOrDefault(c => c.Id == id);
        if (contact == null)
        {
            return NotFound();
        }

        _contacts.Remove(contact);

        _logger.LogInformation("Contact deleted: {Id}", id);

        return NoContent();
    }
}

public record CreateContactRequest(
    string UserId,
    string Name,
    string PhoneNumber,
    string? Email,
    ContactRelationship Relationship,
    bool IsPrimary
);

public record UpdateContactRequest(
    string Name,
    string PhoneNumber,
    string? Email,
    ContactRelationship Relationship,
    bool IsPrimary
);
