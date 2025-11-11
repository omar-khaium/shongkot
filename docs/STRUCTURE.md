# Repository Structure

## Shongkot Emergency Responder - File Organization

This document provides a complete overview of the repository structure.

```
shongkot-emergency-responder/
│
├── .github/                              # GitHub-specific files
│   └── workflows/                        # CI/CD workflows
│       ├── backend-cicd.yml              # Backend build, test, deploy
│       └── frontend-cicd.yml             # Mobile build, test, deploy
│
├── backend/                              # ASP.NET Core Backend API
│   ├── Shongkot.Api/                     # Web API Project
│   │   ├── Controllers/                  # API Controllers
│   │   │   ├── EmergencyController.cs    # Emergency endpoints
│   │   │   └── ContactsController.cs     # Contacts endpoints
│   │   ├── Properties/                   # Project properties
│   │   ├── Program.cs                    # API entry point
│   │   ├── appsettings.json              # Configuration
│   │   └── Shongkot.Api.csproj           # Project file
│   │
│   ├── Shongkot.Application/             # Application Layer
│   │   ├── DTOs/                         # Data Transfer Objects
│   │   ├── Services/                     # Business Services
│   │   ├── Interfaces/                   # Service Contracts
│   │   └── Shongkot.Application.csproj
│   │
│   ├── Shongkot.Domain/                  # Domain Layer
│   │   ├── Entities/                     # Domain Entities
│   │   │   ├── Emergency.cs              # Emergency entity
│   │   │   ├── Contact.cs                # Contact entity
│   │   │   └── Responder.cs              # Responder entity
│   │   ├── Interfaces/                   # Domain Interfaces
│   │   └── Shongkot.Domain.csproj
│   │
│   ├── Shongkot.Infrastructure/          # Infrastructure Layer
│   │   ├── Data/                         # Database Context
│   │   ├── Services/                     # External Services
│   │   └── Shongkot.Infrastructure.csproj
│   │
│   ├── Shongkot.Api.Tests/               # API Tests
│   │   ├── UnitTest1.cs                  # Controller tests
│   │   └── Shongkot.Api.Tests.csproj
│   │
│   ├── Shongkot.Application.Tests/       # Application Tests
│   │   └── Shongkot.Application.Tests.csproj
│   │
│   ├── Shongkot.Integration.Tests/       # Integration Tests
│   │   └── Shongkot.Integration.Tests.csproj
│   │
│   └── Shongkot.sln                      # Solution File
│
├── mobile/                               # Flutter Mobile Application
│   ├── lib/                              # Source Code
│   │   ├── core/                         # Core functionality
│   │   │   ├── theme/                    # App theming
│   │   │   │   └── app_theme.dart
│   │   │   ├── utils/                    # Utilities
│   │   │   │   └── service_locator.dart  # DI setup
│   │   │   ├── constants/                # Constants
│   │   │   └── widgets/                  # Shared widgets
│   │   │
│   │   ├── features/                     # Feature Modules
│   │   │   ├── emergency/                # Emergency Feature
│   │   │   │   ├── data/
│   │   │   │   │   ├── models/           # Data models
│   │   │   │   │   ├── repositories/     # Repository implementations
│   │   │   │   │   └── datasources/      # API clients
│   │   │   │   ├── domain/
│   │   │   │   │   ├── entities/         # Business entities
│   │   │   │   │   │   └── emergency.dart
│   │   │   │   │   ├── repositories/     # Repository interfaces
│   │   │   │   │   └── usecases/         # Business logic
│   │   │   │   └── presentation/
│   │   │   │       ├── bloc/             # State management
│   │   │   │       ├── pages/            # Full screens
│   │   │   │       └── widgets/          # Feature widgets
│   │   │   │
│   │   │   ├── contacts/                 # Contacts Feature
│   │   │   │   ├── data/
│   │   │   │   ├── domain/
│   │   │   │   │   └── entities/
│   │   │   │   │       └── contact.dart
│   │   │   │   └── presentation/
│   │   │   │
│   │   │   └── settings/                 # Settings Feature
│   │   │       ├── data/
│   │   │       ├── domain/
│   │   │       └── presentation/
│   │   │
│   │   ├── main.dart                     # App Entry Point
│   │   └── placeholder_exports.dart      # Development placeholder
│   │
│   ├── test/                             # Test Files
│   │   ├── unit/                         # Unit Tests
│   │   └── widget/                       # Widget Tests
│   │
│   ├── integration_test/                 # Integration Tests
│   ├── test_driver/                      # E2E Test Drivers
│   │
│   ├── assets/                           # Assets
│   │   ├── images/                       # Image assets
│   │   ├── icons/                        # Icon assets
│   │   └── fonts/                        # Font assets
│   │
│   └── pubspec.yaml                      # Flutter Dependencies
│
├── docs/                                 # Documentation
│   ├── ARCHITECTURE.md                   # System architecture
│   ├── SETUP.md                          # Setup instructions
│   └── CONTRIBUTING.md                   # Contribution guidelines
│
├── .gitignore                            # Git ignore rules
├── README.md                             # Project overview
└── LICENSE                               # Shongkot Proprietary License 1.0

```

## Key Directories

### `/mobile`
Flutter mobile application following Clean Architecture with feature-based organization.

### `/backend`
ASP.NET Core Web API following Clean Architecture with layered approach:
- **Api**: Controllers and API endpoints
- **Application**: Business logic and services
- **Domain**: Core business entities
- **Infrastructure**: External dependencies

### `/docs`
All project documentation including architecture, setup guides, and contribution guidelines.

### `.github/workflows`
CI/CD pipeline configurations for automated testing and deployment.

## File Naming Conventions

### Backend (C#)
- PascalCase for classes, methods, and properties
- XML documentation for public APIs

### Mobile (Dart/Flutter)
- snake_case for file names
- lowerCamelCase for variables and functions
- UpperCamelCase for class names

## License

All files in this repository are subject to the Shongkot Proprietary License 1.0.
See LICENSE file for full terms.

Copyright © 2025 Omar Khaium. All Rights Reserved.
