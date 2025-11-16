using Shongkot.Application.Services;
using Shongkot.Domain.Entities;
using System.Collections.Concurrent;
using System.Security.Cryptography;

namespace Shongkot.Infrastructure.Services;

public class MockVerificationService : IVerificationService
{
    private static readonly ConcurrentDictionary<string, VerificationCode> _codes = new();
    private static readonly ConcurrentDictionary<string, DateTime> _lastSent = new();
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
        // Use cryptographically secure random for better security
        var bytes = new byte[4];
        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(bytes);
        }
        var randomNumber = BitConverter.ToUInt32(bytes, 0);
        return (randomNumber % 900000 + 100000).ToString();
    }
}
