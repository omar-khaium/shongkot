using Microsoft.AspNetCore.Mvc;
using Shongkot.Application.Services;
using Shongkot.Domain.Entities;
using System.Collections.Concurrent;
using System.Security.Cryptography;
using System.Text;

namespace Shongkot.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly ILogger<AuthController> _logger;
    private readonly IVerificationService _verificationService;

    public AuthController(ILogger<AuthController> logger, IVerificationService verificationService)
    {
        _logger = logger;
        _verificationService = verificationService;
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
}

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
    // Thread-safe collection for storing users
    private static readonly ConcurrentDictionary<string, User> _users = new();

    public AuthController(ILogger<AuthController> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Register a new user with email or phone
    /// </summary>
    [HttpPost("register")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public ActionResult<RegisterResponse> Register([FromBody] RegisterRequest request)
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

        // Check if user already exists
        var key = request.Email ?? request.PhoneNumber ?? string.Empty;
        var existingUser = _users.Values.FirstOrDefault(u => 
            u.Email == request.Email || u.PhoneNumber == request.PhoneNumber);

        if (existingUser != null)
        {
            return Conflict(new { message = "An account with this email/phone already exists" });
        }

        // Create new user
        var user = new User
        {
            Id = Guid.NewGuid(),
            Email = request.Email,
            PhoneNumber = request.PhoneNumber,
            PasswordHash = HashPassword(request.Password),
            IsEmailVerified = false,
            IsPhoneVerified = false,
            CreatedAt = DateTime.UtcNow
        };

        // Use TryAdd for thread-safe insertion
        if (!_users.TryAdd(key, user))
        {
            return Conflict(new { message = "An account with this email/phone already exists" });
        }

        _logger.LogInformation("User registered: Email={Email}, Phone={Phone}", 
            user.Email, user.PhoneNumber);

        // In a real application, this would:
        // - Save to database with proper transaction handling
        // - Send verification email/SMS
        // - Generate JWT token

        var response = new RegisterResponse
        {
            UserId = user.Id.ToString(),
            Email = user.Email,
            PhoneNumber = user.PhoneNumber,
            Message = "Registration successful"
        };

        return CreatedAtAction(nameof(GetUser), new { id = user.Id }, response);
    }

    /// <summary>
    /// Get user by ID
    /// </summary>
    [HttpGet("users/{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<UserResponse> GetUser(Guid id)
    {
        var user = _users.Values.FirstOrDefault(u => u.Id == id);
        if (user == null)
        {
            return NotFound();
        }

        var response = new UserResponse
        {
            Id = user.Id.ToString(),
            Email = user.Email,
            PhoneNumber = user.PhoneNumber,
            Name = user.Name,
            IsEmailVerified = user.IsEmailVerified,
            IsPhoneVerified = user.IsPhoneVerified,
            CreatedAt = user.CreatedAt
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

        var exists = _users.Values.Any(u => 
            u.Email == emailOrPhone || u.PhoneNumber == emailOrPhone);

        return Ok(new AvailabilityResponse { IsAvailable = !exists });
    }

    /// <summary>
    /// Hash password using SHA256 (better than Base64 but still not production-grade)
    /// For production, use BCrypt, Argon2, or ASP.NET Core Identity's PasswordHasher
    /// </summary>
    private static string HashPassword(string password)
    {
        using var sha256 = SHA256.Create();
        var hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
        return Convert.ToBase64String(hashedBytes);
    }
}

public record RegisterRequest(
    string? Email,
    string? PhoneNumber,
    string Password,
    bool AcceptedTerms
);

public record RegisterResponse
{
    public string UserId { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? PhoneNumber { get; set; }
    public string Message { get; set; } = string.Empty;
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
}

public record AvailabilityResponse
{
    public bool IsAvailable { get; set; }
}
