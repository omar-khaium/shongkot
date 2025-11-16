using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Shongkot.Application.Services;
using Shongkot.Domain.Entities;
using System.Security.Claims;

namespace Shongkot.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly ILogger<AuthController> _logger;
    private readonly IVerificationService _verificationService;
    private readonly IAuthService _authService;

    public AuthController(
        ILogger<AuthController> logger, 
        IVerificationService verificationService,
        IAuthService authService)
    {
        _logger = logger;
        _verificationService = verificationService;
        _authService = authService;
    }

    /// <summary>
    /// Send verification code to email or phone
    /// </summary>
    [HttpPost("send-code")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status429TooManyRequests)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<SendCodeResponse>> SendCode([FromBody] SendCodeRequest request)
    {
        _logger.LogInformation("Sending verification code to {Identifier}", request.Identifier);

        var canResend = await _verificationService.CanResendCodeAsync(request.Identifier);
        if (!canResend)
        {
            return StatusCode(StatusCodes.Status429TooManyRequests, 
                new { Message = "Please wait before requesting a new code" });
        }

        var verificationCode = await _verificationService.GenerateCodeAsync(
            request.Identifier, 
            request.Type
        );

        return Ok(new SendCodeResponse(
            Success: true,
            Message: $"Verification code sent to {request.Identifier}",
            ExpiresAt: verificationCode.ExpiresAt
        ));
    }

    /// <summary>
    /// Verify code for email or phone
    /// </summary>
    [HttpPost("verify")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<VerifyCodeResponse>> VerifyCode([FromBody] VerifyCodeRequest request)
    {
        _logger.LogInformation("Verifying code for {Identifier}", request.Identifier);

        var isValid = await _verificationService.VerifyCodeAsync(request.Identifier, request.Code);

        if (!isValid)
        {
            return BadRequest(new VerifyCodeResponse(
                Success: false,
                Message: "Invalid or expired verification code"
            ));
        }

        return Ok(new VerifyCodeResponse(
            Success: true,
            Message: "Verification successful"
        ));
    }

    /// <summary>
    /// Resend verification code
    /// </summary>
    [HttpPost("resend-code")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status429TooManyRequests)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<SendCodeResponse>> ResendCode([FromBody] SendCodeRequest request)
    {
        // Reuse the SendCode endpoint logic
        return await SendCode(request);
    }

    /// <summary>
    /// Register a new user with email or phone
    /// </summary>
    [HttpPost("register")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<AuthResponse>> Register([FromBody] RegisterRequest request)
    {
        try
        {
            // Validate request
            if (string.IsNullOrWhiteSpace(request.Email) && string.IsNullOrWhiteSpace(request.PhoneNumber))
            {
                return BadRequest(new { message = "Email or phone number is required" });
            }

            if (string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest(new { message = "Password is required" });
            }

            if (!request.AcceptedTerms)
            {
                return BadRequest(new { message = "You must accept the terms and privacy policy" });
            }

            // Register user
            var user = await _authService.RegisterAsync(
                request.Email, 
                request.PhoneNumber, 
                request.Password,
                request.Name
            );

            _logger.LogInformation("User registered: Email={Email}, Phone={Phone}", 
                user.Email, user.PhoneNumber);

            // Auto-login after registration
            var result = await _authService.LoginAsync(
                request.Email ?? request.PhoneNumber ?? string.Empty, 
                request.Password
            );

            if (result == null)
            {
                return Problem("Failed to auto-login after registration");
            }

            var response = new AuthResponse
            {
                UserId = user.Id.ToString(),
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
                Name = user.Name,
                AccessToken = result.Value.tokens.AccessToken,
                RefreshToken = result.Value.tokens.RefreshToken,
                ExpiresAt = result.Value.tokens.ExpiresAt,
                TokenType = "Bearer"
            };

            return CreatedAtAction(nameof(GetUser), new { id = user.Id }, response);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new { message = ex.Message });
        }
    }

    /// <summary>
    /// Login with email/phone and password
    /// </summary>
    [HttpPost("login")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<AuthResponse>> Login([FromBody] LoginRequest request)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(request.EmailOrPhone) || string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest(new { message = "Email/phone and password are required" });
            }

            var result = await _authService.LoginAsync(request.EmailOrPhone, request.Password);

            if (result == null)
            {
                return Unauthorized(new { message = "Invalid email/phone or password" });
            }

            var (user, tokens) = result.Value;

            var response = new AuthResponse
            {
                UserId = user.Id.ToString(),
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
                Name = user.Name,
                PhotoUrl = user.PhotoUrl,
                AccessToken = tokens.AccessToken,
                RefreshToken = tokens.RefreshToken,
                ExpiresAt = tokens.ExpiresAt,
                TokenType = "Bearer"
            };

            _logger.LogInformation("User logged in: {UserId}", user.Id);

            return Ok(response);
        }
        catch (ArgumentException ex)
        {
            _logger.LogWarning(ex, "Invalid argument during login");
            return BadRequest(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Invalid operation during login");
            return BadRequest(new { message = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unexpected error during login");
            return Problem("An error occurred during login");
        }
    }

    /// <summary>
    /// Refresh access token using refresh token
    /// </summary>
    [HttpPost("refresh")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<RefreshTokenResponse>> RefreshToken([FromBody] RefreshTokenRequest request)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(request.RefreshToken))
            {
                return BadRequest(new { message = "Refresh token is required" });
            }

            var tokens = await _authService.RefreshTokenAsync(request.RefreshToken);

            if (tokens == null)
            {
                return Unauthorized(new { message = "Invalid or expired refresh token" });
            }

            var response = new RefreshTokenResponse
            {
                AccessToken = tokens.AccessToken,
                RefreshToken = tokens.RefreshToken,
                ExpiresAt = tokens.ExpiresAt,
                TokenType = "Bearer"
            };

            return Ok(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Token refresh error");
            return Problem("An error occurred during token refresh");
        }
    }

    /// <summary>
    /// Logout and revoke refresh token
    /// </summary>
    [Authorize]
    [HttpPost("logout")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult> Logout()
    {
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
            {
                return Unauthorized();
            }

            await _authService.RevokeRefreshTokenAsync(userId);

            _logger.LogInformation("User logged out: {UserId}", userId);

            return Ok(new { message = "Logged out successfully" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Logout error");
            return Problem("An error occurred during logout");
        }
    }

    /// <summary>
    /// Change password
    /// </summary>
    [Authorize]
    [HttpPost("change-password")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
    {
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
            {
                return Unauthorized();
            }

            if (string.IsNullOrWhiteSpace(request.OldPassword) || string.IsNullOrWhiteSpace(request.NewPassword))
            {
                return BadRequest(new { message = "Old and new passwords are required" });
            }

            await _authService.ChangePasswordAsync(userId, request.OldPassword, request.NewPassword);

            _logger.LogInformation("Password changed for user: {UserId}", userId);

            return Ok(new { message = "Password changed successfully. Please login again." });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Change password error");
            return Problem("An error occurred while changing password");
        }
    }

    /// <summary>
    /// Login with Google
    /// </summary>
    [HttpPost("google")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<AuthResponse>> LoginWithGoogle([FromBody] SocialLoginRequest request)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(request.Token))
            {
                return BadRequest(new { message = "Google token is required" });
            }

            var (user, tokens) = await _authService.LoginWithGoogleAsync(request.Token);

            var response = new AuthResponse
            {
                UserId = user.Id.ToString(),
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
                Name = user.Name,
                PhotoUrl = user.PhotoUrl,
                AccessToken = tokens.AccessToken,
                RefreshToken = tokens.RefreshToken,
                ExpiresAt = tokens.ExpiresAt,
                TokenType = "Bearer"
            };

            _logger.LogInformation("User logged in with Google: {UserId}", user.Id);

            return Ok(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Google login error");
            return Problem("An error occurred during Google login");
        }
    }

    /// <summary>
    /// Login with Facebook
    /// </summary>
    [HttpPost("facebook")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<AuthResponse>> LoginWithFacebook([FromBody] SocialLoginRequest request)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(request.Token))
            {
                return BadRequest(new { message = "Facebook token is required" });
            }

            var (user, tokens) = await _authService.LoginWithFacebookAsync(request.Token);

            var response = new AuthResponse
            {
                UserId = user.Id.ToString(),
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
                Name = user.Name,
                PhotoUrl = user.PhotoUrl,
                AccessToken = tokens.AccessToken,
                RefreshToken = tokens.RefreshToken,
                ExpiresAt = tokens.ExpiresAt,
                TokenType = "Bearer"
            };

            _logger.LogInformation("User logged in with Facebook: {UserId}", user.Id);

            return Ok(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Facebook login error");
            return Problem("An error occurred during Facebook login");
        }
    }

    /// <summary>
    /// Login with Apple
    /// </summary>
    [HttpPost("apple")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<AuthResponse>> LoginWithApple([FromBody] SocialLoginRequest request)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(request.Token))
            {
                return BadRequest(new { message = "Apple token is required" });
            }

            var (user, tokens) = await _authService.LoginWithAppleAsync(request.Token);

            var response = new AuthResponse
            {
                UserId = user.Id.ToString(),
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
                Name = user.Name,
                PhotoUrl = user.PhotoUrl,
                AccessToken = tokens.AccessToken,
                RefreshToken = tokens.RefreshToken,
                ExpiresAt = tokens.ExpiresAt,
                TokenType = "Bearer"
            };

            _logger.LogInformation("User logged in with Apple: {UserId}", user.Id);

            return Ok(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Apple login error");
            return Problem("An error occurred during Apple login");
        }
    }

    /// <summary>
    /// Get user by ID
    /// </summary>
    [HttpGet("users/{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<UserResponse> GetUser(Guid id)
    {
        // This would normally query the database
        // For now, return a simple response
        var response = new UserResponse
        {
            Id = id.ToString(),
            Message = "User endpoint - implementation in progress"
        };

        return Ok(response);
    }

    /// <summary>
    /// Check if email or phone is already registered
    /// </summary>
    [HttpGet("check-availability")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public ActionResult<AvailabilityResponse> CheckAvailability([FromQuery] string emailOrPhone)
    {
        if (string.IsNullOrWhiteSpace(emailOrPhone))
        {
            return BadRequest(new { message = "Email or phone is required" });
        }

        // This would normally query the database
        // For now, return available
        return Ok(new AvailabilityResponse { IsAvailable = true });
    }
}

// Request/Response DTOs
public record SendCodeRequest(
    string Identifier,
    VerificationType Type
);

public record SendCodeResponse(
    bool Success,
    string Message,
    DateTime ExpiresAt
);

public record VerifyCodeRequest(
    string Identifier,
    string Code
);

public record VerifyCodeResponse(
    bool Success,
    string Message
);

public record RegisterRequest(
    string? Email,
    string? PhoneNumber,
    string Password,
    string? Name,
    bool AcceptedTerms
);

public record LoginRequest(
    string EmailOrPhone,
    string Password
);

public record SocialLoginRequest(
    string Token
);

public record RefreshTokenRequest(
    string RefreshToken
);

public record ChangePasswordRequest(
    string OldPassword,
    string NewPassword
);

public record AuthResponse
{
    public string UserId { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? PhoneNumber { get; set; }
    public string? Name { get; set; }
    public string? PhotoUrl { get; set; }
    public string AccessToken { get; set; } = string.Empty;
    public string RefreshToken { get; set; } = string.Empty;
    public DateTime ExpiresAt { get; set; }
    public string TokenType { get; set; } = "Bearer";
}

public record RefreshTokenResponse
{
    public string AccessToken { get; set; } = string.Empty;
    public string RefreshToken { get; set; } = string.Empty;
    public DateTime ExpiresAt { get; set; }
    public string TokenType { get; set; } = "Bearer";
}

public record UserResponse
{
    public string Id { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? PhoneNumber { get; set; }
    public string? Name { get; set; }
    public bool IsEmailVerified { get; set; }
    public bool IsPhoneVerified { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? Message { get; set; }
}

public record AvailabilityResponse
{
    public bool IsAvailable { get; set; }
}
