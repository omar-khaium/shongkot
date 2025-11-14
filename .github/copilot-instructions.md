# Copilot Instructions for Shongkot

## Project Overview

Shongkot is an emergency responder mobile application with:
- **Backend**: ASP.NET Core 9.0 API following Clean Architecture
- **Mobile**: Flutter 3.19+ app following Clean Architecture
- **Architecture**: Clean Architecture with Domain-Driven Design principles

## Technology Stack

### Backend
- Framework: ASP.NET Core 9.0
- Language: C# 12
- Testing: xUnit, Moq
- Architecture: Clean Architecture (API → Application → Domain ← Infrastructure)

### Mobile
- Framework: Flutter 3.19+
- Language: Dart 3.0+
- State Management: flutter_bloc (BLoC pattern)
- Navigation: go_router
- Testing: flutter_test, mockito

## Build & Test Commands

### Backend
```bash
cd backend
dotnet restore
dotnet build --configuration Release
dotnet test --collect:"XPlat Code Coverage"
```

### Mobile
```bash
cd mobile
flutter pub get
flutter analyze
dart format --output=none --set-exit-if-changed .
flutter test --coverage
```

## Coding Standards

### Backend (C#)
- Follow C# Coding Conventions
- Use PascalCase for public members
- Use camelCase for private fields with `_` prefix
- Add XML documentation for public APIs
- Keep methods focused and small
- Target: 80% code coverage

### Mobile (Dart/Flutter)
- Follow Effective Dart guidelines
- Use lowerCamelCase for identifiers
- Use UpperCamelCase for types
- Prefer const constructors when possible
- Use meaningful variable names
- Target: 75% code coverage

## Commit Message Convention

Follow Conventional Commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `test:` Adding or updating tests
- `refactor:` Code refactoring
- `style:` Code style changes
- `perf:` Performance improvements
- `chore:` Maintenance tasks

## Branch Management

- `main` - Production-ready stable version
- `mobile` - Latest stable mobile application code
- `backend` - Latest stable backend API code
- Feature branches → specific branch → `main`

## Testing Requirements

### Backend
- Minimum 80% code coverage
- Unit tests for business logic
- Integration tests for API endpoints
- Test edge cases and error handling

### Mobile
- Minimum 75% code coverage
- Unit tests for business logic
- Widget tests for UI components
- Test state management and user interactions

## Key Principles

1. Follow SOLID principles
2. Write clean, maintainable code
3. Test-driven development
4. Keep dependencies pointing inward (Domain has no dependencies)
5. Always run tests before committing
6. Update documentation when making changes

## Before Submitting PRs

1. Run all tests and ensure they pass
2. Verify code coverage meets requirements
3. Run linters/formatters
4. Update relevant documentation
5. Follow branch management strategy
6. Write clear, descriptive commit messages

## Security

- Never commit secrets or credentials
- Use environment variables for configuration
- Follow security best practices for both platforms
- Validate all user inputs
- Use HTTPS for all API communications
