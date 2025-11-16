using Shongkot.Application.Models;
using Shongkot.Domain.Entities;

namespace Shongkot.Application.Services;

/// <summary>
/// Service for generating and validating JWT tokens
/// </summary>
public interface ITokenService
{
    /// <summary>
    /// Generate access and refresh tokens for a user
    /// </summary>
    TokenResponse GenerateTokens(User user);
    
    /// <summary>
    /// Validate and extract user ID from a refresh token
    /// </summary>
    Guid? ValidateRefreshToken(string refreshToken);
    
    /// <summary>
    /// Generate a new refresh token
    /// </summary>
    string GenerateRefreshToken();
}
