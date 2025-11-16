using Shongkot.Application.Models;
using Shongkot.Domain.Entities;

namespace Shongkot.Application.Services;

/// <summary>
/// Service for authentication operations
/// </summary>
public interface IAuthService
{
    /// <summary>
    /// Authenticate user with email/phone and password
    /// </summary>
    Task<(User user, TokenResponse tokens)?> LoginAsync(string emailOrPhone, string password);
    
    /// <summary>
    /// Refresh access token using refresh token
    /// </summary>
    Task<TokenResponse?> RefreshTokenAsync(string refreshToken);
    
    /// <summary>
    /// Revoke refresh token (logout)
    /// </summary>
    Task RevokeRefreshTokenAsync(Guid userId);
    
    /// <summary>
    /// Register a new user
    /// </summary>
    Task<User> RegisterAsync(string? email, string? phoneNumber, string password, string? name = null);
    
    /// <summary>
    /// Change user password and invalidate all sessions
    /// </summary>
    Task ChangePasswordAsync(Guid userId, string oldPassword, string newPassword);
    
    /// <summary>
    /// Login or register with Google
    /// </summary>
    Task<(User user, TokenResponse tokens)> LoginWithGoogleAsync(string googleToken);
    
    /// <summary>
    /// Login or register with Facebook
    /// </summary>
    Task<(User user, TokenResponse tokens)> LoginWithFacebookAsync(string facebookToken);
    
    /// <summary>
    /// Login or register with Apple
    /// </summary>
    Task<(User user, TokenResponse tokens)> LoginWithAppleAsync(string appleToken);
}
