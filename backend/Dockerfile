# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy solution and project files
COPY Shongkot.sln ./
COPY Shongkot.Api/Shongkot.Api.csproj Shongkot.Api/
COPY Shongkot.Application/Shongkot.Application.csproj Shongkot.Application/
COPY Shongkot.Domain/Shongkot.Domain.csproj Shongkot.Domain/
COPY Shongkot.Infrastructure/Shongkot.Infrastructure.csproj Shongkot.Infrastructure/
COPY Shongkot.Api.Tests/Shongkot.Api.Tests.csproj Shongkot.Api.Tests/
COPY Shongkot.Application.Tests/Shongkot.Application.Tests.csproj Shongkot.Application.Tests/
COPY Shongkot.Integration.Tests/Shongkot.Integration.Tests.csproj Shongkot.Integration.Tests/

# Restore dependencies
RUN dotnet restore

# Copy source code
COPY . .

# Build and publish
WORKDIR /src/Shongkot.Api
RUN dotnet publish -c Release -o /app/publish --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copy published files
COPY --from=build /app/publish .

# Expose port
EXPOSE 8080

# Set environment variables
# Use Development by default to avoid startup failures with default secrets
# Production deployments should override ASPNETCORE_ENVIRONMENT and set proper secrets
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Development

# Run the application
ENTRYPOINT ["dotnet", "Shongkot.Api.dll"]
