using Shongkot.Api.Controllers;
using Shongkot.Domain.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;

namespace Shongkot.Api.Tests;

public class EmergencyControllerTests
{
    private readonly Mock<ILogger<EmergencyController>> _mockLogger;
    private readonly EmergencyController _controller;

    public EmergencyControllerTests()
    {
        _mockLogger = new Mock<ILogger<EmergencyController>>();
        _controller = new EmergencyController(_mockLogger.Object);
    }

    [Fact]
    public void TriggerEmergency_ValidRequest_ReturnsCreatedResult()
    {
        // Arrange
        var request = new CreateEmergencyRequest(
            UserId: "user123",
            Type: EmergencyType.Medical,
            Latitude: 23.8103,
            Longitude: 90.4125,
            Address: "Dhaka, Bangladesh",
            Notes: "Test emergency"
        );

        // Act
        var result = _controller.TriggerEmergency(request);

        // Assert
        var createdResult = Assert.IsType<CreatedAtActionResult>(result.Result);
        var emergency = Assert.IsType<Emergency>(createdResult.Value);
        Assert.Equal("user123", emergency.UserId);
        Assert.Equal(EmergencyType.Medical, emergency.Type);
        Assert.Equal(EmergencyStatus.Active, emergency.Status);
    }

    [Fact]
    public void GetEmergency_ExistingId_ReturnsOkResult()
    {
        // Arrange
        var createRequest = new CreateEmergencyRequest(
            UserId: "user123",
            Type: EmergencyType.Fire,
            Latitude: 23.8103,
            Longitude: 90.4125,
            Address: null,
            Notes: null
        );
        var createResult = _controller.TriggerEmergency(createRequest);
        var createdEmergency = (createResult.Result as CreatedAtActionResult)?.Value as Emergency;

        // Act
        var result = _controller.GetEmergency(createdEmergency!.Id);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        var emergency = Assert.IsType<Emergency>(okResult.Value);
        Assert.Equal(createdEmergency.Id, emergency.Id);
    }

    [Fact]
    public void GetEmergency_NonExistingId_ReturnsNotFound()
    {
        // Arrange
        var nonExistingId = Guid.NewGuid();

        // Act
        var result = _controller.GetEmergency(nonExistingId);

        // Assert
        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public void CancelEmergency_ExistingId_UpdatesStatusToCancelled()
    {
        // Arrange
        var createRequest = new CreateEmergencyRequest(
            UserId: "user123",
            Type: EmergencyType.Assault,
            Latitude: 23.8103,
            Longitude: 90.4125,
            Address: "Test Address",
            Notes: "Test"
        );
        var createResult = _controller.TriggerEmergency(createRequest);
        var createdEmergency = (createResult.Result as CreatedAtActionResult)?.Value as Emergency;

        // Act
        var result = _controller.CancelEmergency(createdEmergency!.Id);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        var emergency = Assert.IsType<Emergency>(okResult.Value);
        Assert.Equal(EmergencyStatus.Cancelled, emergency.Status);
    }

    [Fact]
    public void FindNearbyResponders_ValidLocation_ReturnsResponders()
    {
        // Arrange
        var request = new LocationRequest(23.8103, 90.4125);

        // Act
        var result = _controller.FindNearbyResponders(request);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result.Result);
        var responders = Assert.IsAssignableFrom<IEnumerable<Responder>>(okResult.Value);
        Assert.NotEmpty(responders);
    }
}
