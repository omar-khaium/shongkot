using Shongkot.Application.Services;
using Shongkot.Domain.Entities;

namespace Shongkot.Infrastructure.Services;

public class MockVerificationService : IVerificationService
{
    private static readonly Dictionary<string, VerificationCode> _codes = new();
    private static readonly Dictionary<string, DateTime> _lastSent = new();
    private const int CodeExpirationMinutes = 5;
    private const int ResendCooldownSeconds = 60;

    public Task<VerificationCode> GenerateCodeAsync(string identifier, VerificationType type)
    {
        var code = GenerateRandomCode();
        var verificationCode = new VerificationCode
        {
            Id = Guid.NewGuid(),
            Identifier = identifier,
            Type = type,
            Code = code,
            ExpiresAt = DateTime.UtcNow.AddMinutes(CodeExpirationMinutes),
            IsUsed = false,
            CreatedAt = DateTime.UtcNow
        };

        _codes[identifier] = verificationCode;
        _lastSent[identifier] = DateTime.UtcNow;

        // In production, this would send SMS/Email
        Console.WriteLine($"[MOCK] Verification code for {identifier}: {code}");

        return Task.FromResult(verificationCode);
    }

    public Task<bool> VerifyCodeAsync(string identifier, string code)
    {
        if (!_codes.TryGetValue(identifier, out var verificationCode))
        {
            return Task.FromResult(false);
        }

        if (verificationCode.IsUsed)
        {
            return Task.FromResult(false);
        }

        if (DateTime.UtcNow > verificationCode.ExpiresAt)
        {
            return Task.FromResult(false);
        }

        if (verificationCode.Code != code)
        {
            return Task.FromResult(false);
        }

        verificationCode.IsUsed = true;
        verificationCode.UsedAt = DateTime.UtcNow;

        return Task.FromResult(true);
    }

    public Task<bool> CanResendCodeAsync(string identifier)
    {
        if (!_lastSent.TryGetValue(identifier, out var lastSent))
        {
            return Task.FromResult(true);
        }

        var timeSinceLastSent = DateTime.UtcNow - lastSent;
        return Task.FromResult(timeSinceLastSent.TotalSeconds >= ResendCooldownSeconds);
    }

    private static string GenerateRandomCode()
    {
        var random = new Random();
        return random.Next(100000, 999999).ToString();
    }
}
