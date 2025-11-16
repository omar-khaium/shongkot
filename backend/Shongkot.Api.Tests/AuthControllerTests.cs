using Shongkot.Api.Controllers;
using Shongkot.Application.Services;
using Shongkot.Domain.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;

namespace Shongkot.Api.Tests;

public class AuthControllerTests
{
    private readonly Mock<ILogger<AuthController>> _mockLogger;
    private readonly Mock<IVerificationService> _mockVerificationService;
    private readonly Mock<IAuthService> _mockAuthService;
    private readonly AuthController _controller;

    public AuthControllerTests()
    {
        _mockLogger = new Mock<ILogger<AuthController>>();
        _mockVerificationService = new Mock<IVerificationService>();
        _mockAuthService = new Mock<IAuthService>();
        _controller = new AuthController(_mockLogger.Object, _mockVerificationService.Object, _mockAuthService.Object);
    }

    [Fact]
    public async Task SendCode_ValidRequest_ReturnsOkResult()
    {
        // Arrange
        var request = new SendCodeRequest(
            Identifier: "test@example.com",
            Type: VerificationType.Email
        );

        var verificationCode = new VerificationCode
        {
            Id = Guid.NewGuid(),
            Identifier = request.Identifier,
            Type = request.Type,
            Code = "123456",
            ExpiresAt = DateTime.UtcNow.AddMinutes(5),
            IsUsed = false,
            CreatedAt = DateTime.UtcNow
        };

        _mockVerificationService
            .Setup(s => s.CanResendCodeAsync(request.Identifier))
            .ReturnsAsync(true);

        _mockVerificationService
            .Setup(s => s.GenerateCodeAsync(request.Identifier, request.Type))
            .ReturnsAsync(verificationCode);

        // Act
        var result = await _controller.SendCode(request);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        var response = Assert.IsType<SendCodeResponse>(okResult.Value);
        Assert.True(response.Success);
        Assert.Contains("sent", response.Message);
    }

    [Fact]
    public async Task SendCode_TooManyRequests_ReturnsTooManyRequestsStatus()
    {
        // Arrange
        var request = new SendCodeRequest(
            Identifier: "test@example.com",
            Type: VerificationType.Email
        );

        _mockVerificationService
            .Setup(s => s.CanResendCodeAsync(request.Identifier))
            .ReturnsAsync(false);

        // Act
        var result = await _controller.SendCode(request);

        // Assert
        var statusCodeResult = Assert.IsType<ObjectResult>(result.Result);
        Assert.Equal(429, statusCodeResult.StatusCode);
    }

    [Fact]
    public async Task VerifyCode_ValidCode_ReturnsOkResult()
    {
        // Arrange
        var request = new VerifyCodeRequest(
            Identifier: "test@example.com",
            Code: "123456"
        );

        _mockVerificationService
            .Setup(s => s.VerifyCodeAsync(request.Identifier, request.Code))
            .ReturnsAsync(true);

        // Act
        var result = await _controller.VerifyCode(request);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        var response = Assert.IsType<VerifyCodeResponse>(okResult.Value);
        Assert.True(response.Success);
        Assert.Equal("Verification successful", response.Message);
    }

    [Fact]
    public async Task VerifyCode_InvalidCode_ReturnsBadRequest()
    {
        // Arrange
        var request = new VerifyCodeRequest(
            Identifier: "test@example.com",
            Code: "wrong"
        );

        _mockVerificationService
            .Setup(s => s.VerifyCodeAsync(request.Identifier, request.Code))
            .ReturnsAsync(false);

        // Act
        var result = await _controller.VerifyCode(request);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result.Result);
        var response = Assert.IsType<VerifyCodeResponse>(badRequestResult.Value);
        Assert.False(response.Success);
        Assert.Contains("Invalid or expired", response.Message);
    }

    [Fact]
    public async Task ResendCode_ValidRequest_ReturnsOkResult()
    {
        // Arrange
        var request = new SendCodeRequest(
            Identifier: "+8801234567890",
            Type: VerificationType.Phone
        );

        var verificationCode = new VerificationCode
        {
            Id = Guid.NewGuid(),
            Identifier = request.Identifier,
            Type = request.Type,
            Code = "654321",
            ExpiresAt = DateTime.UtcNow.AddMinutes(5),
            IsUsed = false,
            CreatedAt = DateTime.UtcNow
        };

        _mockVerificationService
            .Setup(s => s.CanResendCodeAsync(request.Identifier))
            .ReturnsAsync(true);

        _mockVerificationService
            .Setup(s => s.GenerateCodeAsync(request.Identifier, request.Type))
            .ReturnsAsync(verificationCode);

        // Act
        var result = await _controller.ResendCode(request);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        var response = Assert.IsType<SendCodeResponse>(okResult.Value);
        Assert.True(response.Success);
    }
}
