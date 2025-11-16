using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Shongkot.Application.Models;
using Shongkot.Application.Services;
using Shongkot.Domain.Entities;

namespace Shongkot.Infrastructure.Services;

/// <summary>
/// Implementation of token service using JWT
/// </summary>
public class TokenService : ITokenService
{
    private readonly JwtSettings _jwtSettings;

    public TokenService(IOptions<JwtSettings> jwtSettings)
    {
        _jwtSettings = jwtSettings.Value;
    }

    public TokenResponse GenerateTokens(User user)
    {
        var accessToken = GenerateAccessToken(user);
        var refreshToken = GenerateRefreshToken();
        var expiresAt = DateTime.UtcNow.AddMinutes(_jwtSettings.AccessTokenExpirationMinutes);

        return new TokenResponse
        {
            AccessToken = accessToken,
            RefreshToken = refreshToken,
            ExpiresAt = expiresAt,
            TokenType = "Bearer"
        };
    }

    /// <summary>
    /// Validates a refresh token. Note: Refresh tokens are random strings stored in the database,
    /// not JWTs. This method is not used in the current implementation as validation is done
    /// by comparing stored tokens in AuthService.
    /// </summary>
    public Guid? ValidateRefreshToken(string refreshToken)
    {
        // Refresh tokens are random strings, not JWTs.
        // Token validation is done by the AuthService by comparing stored tokens.
        // This method exists for interface compliance but should not be used.
        throw new NotImplementedException(
            "Refresh token validation is handled by AuthService through token comparison, not JWT validation");
    }

    public string GenerateRefreshToken()
    {
        var randomNumber = new byte[32];
        using var rng = RandomNumberGenerator.Create();
        rng.GetBytes(randomNumber);
        return Convert.ToBase64String(randomNumber);
    }

    private string GenerateAccessToken(User user)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(_jwtSettings.SecretKey);

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        if (!string.IsNullOrEmpty(user.Email))
        {
            claims.Add(new Claim(ClaimTypes.Email, user.Email));
            claims.Add(new Claim(JwtRegisteredClaimNames.Email, user.Email));
        }

        if (!string.IsNullOrEmpty(user.Name))
        {
            claims.Add(new Claim(ClaimTypes.Name, user.Name));
        }

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.UtcNow.AddMinutes(_jwtSettings.AccessTokenExpirationMinutes),
            Issuer = _jwtSettings.Issuer,
            Audience = _jwtSettings.Audience,
            SigningCredentials = new SigningCredentials(
                new SymmetricSecurityKey(key),
                SecurityAlgorithms.HmacSha256Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}
