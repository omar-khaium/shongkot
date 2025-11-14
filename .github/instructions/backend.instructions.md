---
applies_to: backend/
---

# Backend Instructions (.NET/C#)

## Architecture

Follow Clean Architecture with clear layer separation:

### Layers (in order of dependency)
1. **Domain** (`Shongkot.Domain`) - Core business entities, no dependencies
2. **Application** (`Shongkot.Application`) - Business logic, depends on Domain
3. **Infrastructure** (`Shongkot.Infrastructure`) - Data access, external services
4. **API** (`Shongkot.Api`) - HTTP endpoints, depends on Application

### Dependencies Flow
```
API → Application → Domain
         ↓
   Infrastructure
```

## Project Structure

- **Domain**: Entities, value objects, domain services, repository interfaces
- **Application**: Use cases, DTOs, service interfaces, validators
- **Infrastructure**: Database context, repository implementations, external API clients
- **API**: Controllers, middleware, DTOs for API contracts

## Coding Standards

### Naming Conventions
- **Classes**: PascalCase (`EmergencyService`)
- **Interfaces**: PascalCase with `I` prefix (`IEmergencyRepository`)
- **Methods**: PascalCase (`TriggerEmergency`)
- **Private fields**: camelCase with `_` prefix (`_logger`)
- **Constants**: PascalCase or UPPER_CASE

### Documentation
```csharp
/// <summary>
/// Brief description of what this does
/// </summary>
/// <param name="parameter">Parameter description</param>
/// <returns>Return value description</returns>
public async Task<Result> MethodName(Parameter parameter)
```

### Async/Await
- Always use async/await for I/O operations
- Append `Async` to async method names
- Use `Task<T>` or `Task` return types

### Error Handling
- Use try-catch for expected errors
- Use proper exception types
- Return appropriate HTTP status codes
- Log errors with structured logging

## Testing Requirements

### Test Structure
```
Shongkot.{Layer}.Tests/
├── Unit/           # Pure logic tests
├── Integration/    # Database/API tests
└── Fixtures/       # Test data builders
```

### Test Naming
```csharp
public class EmergencyServiceTests
{
    [Fact]
    public async Task TriggerEmergency_WithValidRequest_ShouldCreateEmergency()
    {
        // Arrange
        // Act
        // Assert
    }
}
```

### Coverage Requirements
- Unit tests: 80% minimum
- Test all business logic
- Test edge cases and error paths
- Mock external dependencies

## Dependencies

### Adding NuGet Packages
```bash
cd Shongkot.{Project}
dotnet add package PackageName
```

### Common Packages
- **API**: ASP.NET Core, Swashbuckle
- **Application**: FluentValidation, AutoMapper
- **Infrastructure**: Entity Framework Core, Dapper
- **Testing**: xUnit, Moq, FluentAssertions

## Build & Test Commands

```bash
# Restore packages
dotnet restore

# Build
dotnet build --configuration Release

# Run all tests
dotnet test

# Run specific test project
dotnet test Shongkot.Api.Tests/

# With coverage
dotnet test --collect:"XPlat Code Coverage"

# Run API locally
cd Shongkot.Api
dotnet run
```

## API Guidelines

### Controller Structure
```csharp
[ApiController]
[Route("api/[controller]")]
public class EmergencyController : ControllerBase
{
    private readonly IEmergencyService _service;
    
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<EmergencyDto>> Create([FromBody] CreateEmergencyRequest request)
    {
        // Implementation
    }
}
```

### DTOs
- Create separate DTOs for API contracts
- Don't expose domain entities directly
- Use data annotations for validation
- Keep DTOs in the API layer

## Configuration

- Use `appsettings.json` for configuration
- Use environment variables for secrets
- Never commit secrets to source control
- Use User Secrets for local development

## Before Committing

1. Run `dotnet build` - ensure no compilation errors
2. Run `dotnet test` - ensure all tests pass
3. Check code coverage meets 80% minimum
4. Ensure no TODO comments remain
5. Update XML documentation for public APIs
