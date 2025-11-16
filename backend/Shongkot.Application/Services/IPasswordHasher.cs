namespace Shongkot.Application.Services;

/// <summary>
/// Service for password hashing and verification
/// </summary>
public interface IPasswordHasher
{
    /// <summary>
    /// Hash a password
    /// </summary>
    string HashPassword(string password);
    
    /// <summary>
    /// Verify password against hash
    /// </summary>
    bool VerifyPassword(string password, string hash);
}
