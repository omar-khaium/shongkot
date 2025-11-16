using Microsoft.AspNetCore.Mvc;
using Shongkot.Application.Services;
using Shongkot.Domain.Entities;

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
