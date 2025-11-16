using Shongkot.Domain.Entities;

namespace Shongkot.Application.Services;

public interface IVerificationService
{
    /// <summary>
    /// Generates and sends a verification code
    /// </summary>
    Task<VerificationCode> GenerateCodeAsync(string identifier, VerificationType type);
    
    /// <summary>
    /// Verifies a code for the given identifier
    /// </summary>
    Task<bool> VerifyCodeAsync(string identifier, string code);
    
    /// <summary>
    /// Checks if resend is allowed (rate limiting)
    /// </summary>
    Task<bool> CanResendCodeAsync(string identifier);
}
