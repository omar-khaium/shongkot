using System.Collections.Concurrent;
using Shongkot.Application.Models;
using Shongkot.Application.Services;
using Shongkot.Domain.Entities;

namespace Shongkot.Infrastructure.Services;

/// <summary>
/// Implementation of authentication service
/// In production, this should use a real database
/// </summary>
public class AuthService : IAuthService
{
    private readonly ITokenService _tokenService;
    private readonly IPasswordHasher _passwordHasher;
    
    // Thread-safe in-memory storage (replace with database in production)
    private static readonly ConcurrentDictionary<Guid, User> _users = new();
    private static readonly ConcurrentDictionary<string, Guid> _emailIndex = new();
    private static readonly ConcurrentDictionary<string, Guid> _phoneIndex = new();
    private static readonly ConcurrentDictionary<string, Guid> _googleIdIndex = new();
    private static readonly ConcurrentDictionary<string, Guid> _facebookIdIndex = new();
    private static readonly ConcurrentDictionary<string, Guid> _appleIdIndex = new();

    public AuthService(ITokenService tokenService, IPasswordHasher passwordHasher)
    {
        _tokenService = tokenService;
        _passwordHasher = passwordHasher;
    }

    public async Task<(User user, TokenResponse tokens)?> LoginAsync(string emailOrPhone, string password)
    {
        await Task.CompletedTask; // Simulate async

        var normalizedKey = emailOrPhone.Trim().ToLowerInvariant();
        
        // Find user by email or phone
        Guid userId;
        if (emailOrPhone.Contains('@'))
        {
            if (!_emailIndex.TryGetValue(normalizedKey, out userId))
                return null;
        }
        else
        {
            if (!_phoneIndex.TryGetValue(normalizedKey, out userId))
                return null;
        }

        if (!_users.TryGetValue(userId, out var user))
            return null;

        // Verify password
        if (!_passwordHasher.VerifyPassword(password, user.PasswordHash))
            return null;

        // Generate tokens
        var tokens = _tokenService.GenerateTokens(user);
        
        // Update refresh token in user
        user.RefreshToken = tokens.RefreshToken;
        user.RefreshTokenExpiresAt = DateTime.UtcNow.AddDays(7); // Should match JWT settings
        
        return (user, tokens);
    }

    public async Task<TokenResponse?> RefreshTokenAsync(string refreshToken)
    {
        await Task.CompletedTask; // Simulate async

        // Find user with this refresh token
        var user = _users.Values.FirstOrDefault(u => 
            u.RefreshToken == refreshToken && 
            u.RefreshTokenExpiresAt > DateTime.UtcNow);

        if (user == null)
            return null;

        // Generate new tokens
        var tokens = _tokenService.GenerateTokens(user);
        
        // Update refresh token
        user.RefreshToken = tokens.RefreshToken;
        user.RefreshTokenExpiresAt = DateTime.UtcNow.AddDays(7);
        
        return tokens;
    }

    public async Task RevokeRefreshTokenAsync(Guid userId)
    {
        await Task.CompletedTask; // Simulate async

        if (_users.TryGetValue(userId, out var user))
        {
            user.RefreshToken = null;
            user.RefreshTokenExpiresAt = null;
        }
    }

    public async Task<User> RegisterAsync(string? email, string? phoneNumber, string password, string? name = null)
    {
        await Task.CompletedTask; // Simulate async

        // Validate input
        if (string.IsNullOrWhiteSpace(email) && string.IsNullOrWhiteSpace(phoneNumber))
            throw new ArgumentException("Email or phone number is required");

        if (string.IsNullOrWhiteSpace(password))
            throw new ArgumentException("Password is required");

        // Check if user already exists
        var normalizedEmail = email?.Trim().ToLowerInvariant();
        var normalizedPhone = phoneNumber?.Trim();

        if (normalizedEmail != null && _emailIndex.ContainsKey(normalizedEmail))
            throw new InvalidOperationException("An account with this email already exists");

        if (normalizedPhone != null && _phoneIndex.ContainsKey(normalizedPhone))
            throw new InvalidOperationException("An account with this phone already exists");

        // Create user
        var user = new User
        {
            Id = Guid.NewGuid(),
            Email = normalizedEmail,
            PhoneNumber = normalizedPhone,
            Name = name,
            PasswordHash = _passwordHasher.HashPassword(password),
            IsEmailVerified = false,
            IsPhoneVerified = false,
            CreatedAt = DateTime.UtcNow,
            PasswordChangedAt = DateTime.UtcNow
        };

        // Store user
        _users[user.Id] = user;
        if (normalizedEmail != null)
            _emailIndex[normalizedEmail] = user.Id;
        if (normalizedPhone != null)
            _phoneIndex[normalizedPhone] = user.Id;

        return user;
    }

    public async Task ChangePasswordAsync(Guid userId, string oldPassword, string newPassword)
    {
        await Task.CompletedTask; // Simulate async

        if (!_users.TryGetValue(userId, out var user))
            throw new InvalidOperationException("User not found");

        // Verify old password
        if (!_passwordHasher.VerifyPassword(oldPassword, user.PasswordHash))
            throw new InvalidOperationException("Invalid current password");

        // Update password and invalidate all sessions
        user.PasswordHash = _passwordHasher.HashPassword(newPassword);
        user.PasswordChangedAt = DateTime.UtcNow;
        user.RefreshToken = null;
        user.RefreshTokenExpiresAt = null;
        user.UpdatedAt = DateTime.UtcNow;
    }

    public async Task<(User user, TokenResponse tokens)> LoginWithGoogleAsync(string googleToken)
    {
        await Task.CompletedTask; // Simulate async
        
        // In production, verify the Google token with Google's API
        // For now, we'll extract a fake Google ID from the token
        var googleId = ExtractGoogleId(googleToken);
        
        // Find or create user
        User user;
        if (_googleIdIndex.TryGetValue(googleId, out var userId))
        {
            user = _users[userId];
        }
        else
        {
            // Create new user from Google profile
            user = new User
            {
                Id = Guid.NewGuid(),
                GoogleId = googleId,
                Email = $"google_{googleId}@example.com", // Replace with actual email from Google
                Name = "Google User", // Replace with actual name from Google
                PasswordHash = string.Empty, // No password for social login
                IsEmailVerified = true, // Google verifies emails
                CreatedAt = DateTime.UtcNow
            };
            
            _users[user.Id] = user;
            _googleIdIndex[googleId] = user.Id;
            if (user.Email != null)
                _emailIndex[user.Email.ToLowerInvariant()] = user.Id;
        }
        
        var tokens = _tokenService.GenerateTokens(user);
        user.RefreshToken = tokens.RefreshToken;
        user.RefreshTokenExpiresAt = DateTime.UtcNow.AddDays(7);
        
        return (user, tokens);
    }

    public async Task<(User user, TokenResponse tokens)> LoginWithFacebookAsync(string facebookToken)
    {
        await Task.CompletedTask; // Simulate async
        
        // In production, verify the Facebook token with Facebook's API
        var facebookId = ExtractFacebookId(facebookToken);
        
        // Find or create user
        User user;
        if (_facebookIdIndex.TryGetValue(facebookId, out var userId))
        {
            user = _users[userId];
        }
        else
        {
            user = new User
            {
                Id = Guid.NewGuid(),
                FacebookId = facebookId,
                Email = $"facebook_{facebookId}@example.com",
                Name = "Facebook User",
                PasswordHash = string.Empty,
                IsEmailVerified = true,
                CreatedAt = DateTime.UtcNow
            };
            
            _users[user.Id] = user;
            _facebookIdIndex[facebookId] = user.Id;
            if (user.Email != null)
                _emailIndex[user.Email.ToLowerInvariant()] = user.Id;
        }
        
        var tokens = _tokenService.GenerateTokens(user);
        user.RefreshToken = tokens.RefreshToken;
        user.RefreshTokenExpiresAt = DateTime.UtcNow.AddDays(7);
        
        return (user, tokens);
    }

    public async Task<(User user, TokenResponse tokens)> LoginWithAppleAsync(string appleToken)
    {
        await Task.CompletedTask; // Simulate async
        
        // In production, verify the Apple token with Apple's API
        var appleId = ExtractAppleId(appleToken);
        
        // Find or create user
        User user;
        if (_appleIdIndex.TryGetValue(appleId, out var userId))
        {
            user = _users[userId];
        }
        else
        {
            user = new User
            {
                Id = Guid.NewGuid(),
                AppleId = appleId,
                Email = $"apple_{appleId}@privaterelay.appleid.com",
                Name = "Apple User",
                PasswordHash = string.Empty,
                IsEmailVerified = true,
                CreatedAt = DateTime.UtcNow
            };
            
            _users[user.Id] = user;
            _appleIdIndex[appleId] = user.Id;
            if (user.Email != null)
                _emailIndex[user.Email.ToLowerInvariant()] = user.Id;
        }
        
        var tokens = _tokenService.GenerateTokens(user);
        user.RefreshToken = tokens.RefreshToken;
        user.RefreshTokenExpiresAt = DateTime.UtcNow.AddDays(7);
        
        return (user, tokens);
    }

    // Helper methods to extract IDs from tokens (mock implementation)
    private string ExtractGoogleId(string token) => $"google_{token.GetHashCode()}";
    private string ExtractFacebookId(string token) => $"facebook_{token.GetHashCode()}";
    private string ExtractAppleId(string token) => $"apple_{token.GetHashCode()}";
}
