# Shongkot - Complete Documentation Wiki

**⚠️ PROPRIETARY SOFTWARE - All Rights Reserved**

Copyright © 2025 Omar Khaium

---

## Table of Contents

1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [Architecture](#architecture)
4. [Setup Instructions](#setup-instructions)
5. [Development Workflow](#development-workflow)
6. [Deployment Guide](#deployment-guide)
7. [Branch Strategy](#branch-strategy)
8. [CI/CD Pipeline](#cicd-pipeline)
9. [Testing](#testing)
10. [Contributing](#contributing)
11. [Security](#security)

---

## Overview

**Shongkot** is a proprietary emergency responder mobile application that simplifies emergency response coordination. When someone faces an emergency (accident, health crisis, fire, assault, etc.), they often lose valuable minutes trying to reach the right service. Shongkot solves this problem:

- **One button** connects users to nearby responders
- **Live location** sharing in real-time
- **Automatic alerts** to family and friends
- **Quick access** to emergency services

---

## Repository Structure

```
shongkot-emergency-responder/
├── mobile/                    # Flutter mobile application
│   ├── lib/                   # Application source code
│   ├── test/                  # Unit and widget tests
│   ├── integration_test/      # Integration tests
│   └── pubspec.yaml           # Flutter dependencies
│
├── backend/                   # ASP.NET Core API
│   ├── Shongkot.Api/          # Web API layer
│   ├── Shongkot.Application/  # Application logic
│   ├── Shongkot.Domain/       # Domain entities
│   ├── Shongkot.Infrastructure/ # Infrastructure layer
│   └── Tests/                 # Backend tests
│       ├── Shongkot.Api.Tests/
│       ├── Shongkot.Application.Tests/
│       └── Shongkot.Integration.Tests/
│
├── docs/                      # Documentation
│   ├── ARCHITECTURE.md        # System architecture
│   ├── SETUP.md               # Setup instructions
│   ├── DEPLOYMENT.md          # Deployment guide
│   ├── CONTRIBUTING.md        # Contribution guidelines
│   └── WIKI.md                # This comprehensive wiki
│
├── .github/                   # GitHub Actions workflows
│   └── workflows/
│       ├── backend-cicd.yml   # Backend CI/CD
│       └── frontend-cicd.yml  # Frontend CI/CD
│
├── .gitignore                 # Git ignore rules
├── README.md                  # Quick reference
└── LICENSE                    # Shongkot Proprietary License 1.0
```

---

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Mobile Application                       │
│                        (Flutter)                            │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Presentation │  │   Business   │  │     Data     │    │
│  │    Layer     │  │    Logic     │  │    Layer     │    │
│  │   (UI/Bloc)  │  │  (Use Cases) │  │ (Repository) │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │ HTTPS/REST
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     Backend API                              │
│                  (ASP.NET Core 9.0)                         │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Controllers  │  │  Application │  │     Domain   │    │
│  │   (API)      │  │   Services   │  │   Entities   │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│           │                │                  │            │
│           └────────────────┴──────────────────┘            │
│                           │                                │
│                  ┌────────┴────────┐                       │
│                  │ Infrastructure  │                       │
│                  │    (Data/IO)    │                       │
│                  └─────────────────┘                       │
└───────────────────────────┬─────────────────────────────────┘
                            │
             ┌──────────────┴──────────────┐
             │                             │
             ▼                             ▼
     ┌───────────────┐           ┌─────────────────┐
     │   Database    │           │  External APIs  │
     │ (SQL Server)  │           │  (Maps, SMS)    │
     └───────────────┘           └─────────────────┘
```

### Backend Architecture (ASP.NET Core)

This project follows Clean Architecture principles with clear separation of concerns:

#### API Layer (`Shongkot.Api`)
- Controllers for HTTP endpoints
- Middleware for cross-cutting concerns
- API versioning and routing
- Swagger/OpenAPI documentation

#### Application Layer (`Shongkot.Application`)
- Business logic and use cases
- DTOs (Data Transfer Objects)
- Service interfaces
- Application services

#### Domain Layer (`Shongkot.Domain`)
- Core business entities
- Domain interfaces
- Business rules
- Domain events

#### Infrastructure Layer (`Shongkot.Infrastructure`)
- Database implementations
- External API integrations
- File system access
- Third-party service integrations

### Frontend Architecture (Flutter)

```
mobile/
├── lib/
│   ├── core/                  # Core utilities, theme, constants
│   ├── features/              # Feature modules
│   │   └── {feature}/
│   │       ├── data/          # Data layer (models, repositories, datasources)
│   │       ├── domain/        # Domain layer (entities, use cases)
│   │       └── presentation/  # UI layer (pages, widgets, bloc)
│   └── main.dart
├── test/                      # Unit and widget tests
└── integration_test/          # Integration tests
```

#### Feature Structure
Each feature follows clean architecture:
- **Data Layer**: API clients, local storage, repositories implementation
- **Domain Layer**: Entities, repository interfaces, use cases
- **Presentation Layer**: Pages, widgets, BLoC/state management

---

## Setup Instructions

### Prerequisites

**Backend:**
- [.NET 9.0 SDK](https://dotnet.microsoft.com/download)
- Visual Studio 2022+ or VS Code with C# extension
- SQL Server (optional, for production)

**Frontend:**
- [Flutter 3.19+](https://flutter.dev/docs/get-started/install)
- Android Studio / Xcode (for mobile development)
- [Firebase account](https://firebase.google.com/) (for notifications)

### Backend Setup

1. **Navigate to backend directory:**
```bash
cd backend
```

2. **Restore dependencies:**
```bash
dotnet restore
```

3. **Build the solution:**
```bash
dotnet build
```

4. **Run the API:**
```bash
cd Shongkot.Api
dotnet run
```

5. **Access Swagger UI:**
```
https://localhost:5001/swagger
```

### Frontend Setup

1. **Navigate to mobile directory:**
```bash
cd mobile
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Configure Firebase:**
   - Create a Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

4. **Run the app:**
```bash
flutter run
```

For detailed setup instructions, see [SETUP.md](SETUP.md).

---

## Development Workflow

### Branch Strategy

The repository uses a multi-branch strategy for organized development:

- **`main`** - Production-ready code, most stable version
- **`mobile`** - Latest stable mobile code, mobile PRs merge here
- **`backend`** - Latest stable backend code, backend PRs merge here

### Development Process

1. **Create feature branch** from appropriate base:
   - Mobile features: branch from `mobile`
   - Backend features: branch from `backend`

2. **Make changes** and commit regularly

3. **Test locally** before pushing

4. **Create Pull Request** to appropriate branch:
   - Mobile PRs → `mobile` branch
   - Backend PRs → `backend` branch

5. **CI/CD runs automatically** for relevant code only

6. **After approval**, changes merge to feature branch

7. **Periodically merge** feature branches to `main` for releases

### Local Development

#### Backend
```bash
cd backend
dotnet restore
dotnet build
dotnet run --project Shongkot.Api
```

#### Frontend
```bash
cd mobile
flutter pub get
flutter run
```

---

## Deployment Guide

### Backend Deployment (Google Cloud Run)

The backend API is automatically deployed to Google Cloud Run via GitHub Actions.

#### Prerequisites
- Google Cloud account
- Cloud Run service configured
- GitHub secrets set up:
  - `GCP_PROJECT_ID`
  - `GCP_REGION`
  - `CLOUD_RUN_SERVICE`
  - `GCP_ARTIFACT_REPOSITORY`
  - `GCP_SA_KEY`

#### Deployment Process
1. Push to `main` or `backend` branch
2. CI/CD builds Docker image
3. Pushes to Artifact Registry
4. Deploys to Cloud Run
5. Updates README with deployment info

#### Manual Deployment
```bash
cd backend
gcloud builds submit --tag gcr.io/PROJECT_ID/shongkot-api
gcloud run deploy shongkot-api --image gcr.io/PROJECT_ID/shongkot-api --platform managed
```

### Frontend Deployment (Firebase App Distribution)

Mobile builds are distributed via Firebase App Distribution.

#### Prerequisites
- Firebase project
- Firebase App Distribution configured
- GitHub secrets:
  - `FIREBASE_APP_ID`
  - `FIREBASE_SERVICE_CREDENTIALS`
  - `FIREBASE_PROJECT_ID`
  - `FIREBASE_TOKEN`

#### Deployment Process
1. Push to `main` or `mobile` branch
2. CI/CD builds APK and AAB
3. Uploads to Firebase App Distribution
4. Notifies testers
5. In-app updates enabled

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).

---

## Branch Strategy

### Overview

The repository uses a structured branch strategy to manage mobile and backend development independently while maintaining a stable main branch.

### Branch Types

#### Main Branch
- **Purpose**: Production-ready, most stable code
- **Updates**: Only from tested mobile/backend branches
- **Deployments**: Full stack deployments
- **Protection**: Requires PR approval

#### Mobile Branch
- **Purpose**: Latest stable mobile application code
- **Source**: Mobile feature branches
- **CI/CD**: Frontend-only workflows
- **Testing**: Mobile tests only

#### Backend Branch
- **Purpose**: Latest stable backend API code
- **Source**: Backend feature branches
- **CI/CD**: Backend-only workflows
- **Testing**: Backend tests only

#### Feature Branches
- **Naming**: `feature/description` or `fix/description`
- **Lifetime**: Short-lived, deleted after merge
- **Base**: Created from mobile or backend branch

### Workflow

```
feature/mobile-xyz → mobile → main
feature/backend-abc → backend → main
```

---

## CI/CD Pipeline

### Backend Pipeline

**Triggers:** Push/PR to `main` or `backend` branches with backend changes

**Jobs:**
1. Build and Test
   - Restore dependencies
   - Build solution
   - Run unit tests
   - Code coverage report

2. Docker Build
   - Build Docker image
   - Test container health

3. Deploy
   - Push to Artifact Registry
   - Deploy to Cloud Run
   - Verify deployment

4. Update Documentation
   - Update README with deployment info
   - Commit changes back

### Frontend Pipeline

**Triggers:** Push/PR to `main` or `mobile` branches with mobile changes

**Jobs:**
1. Analyze and Test
   - Code formatting
   - Static analysis
   - Unit tests
   - Widget tests

2. Build
   - Build APK (release)
   - Build AAB (release)
   - Upload artifacts

3. Deploy
   - Upload to Firebase App Distribution
   - Create GitHub release
   - Notify testers

---

## Testing

### Backend Tests

```bash
cd backend

# Run all tests
dotnet test

# Run with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run specific test project
dotnet test Shongkot.Api.Tests
```

### Frontend Tests

```bash
cd mobile

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run widget tests
flutter test test/widget

# Run integration tests
flutter test integration_test
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

### Quick Guidelines

1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Ensure all tests pass
5. Submit pull request
6. Wait for review

### Code Standards

- **Backend**: Follow C# conventions, use async/await
- **Frontend**: Follow Dart style guide, use BLoC pattern
- **Tests**: Maintain >80% code coverage
- **Documentation**: Update docs with changes

---

## Security

### Security Measures

- All API endpoints use HTTPS
- Input validation and sanitization
- Rate limiting on critical endpoints
- Security scanning in CI/CD pipeline
- Regular dependency updates
- Secret management via environment variables

### Reporting Security Issues

Contact repository owner directly:
- GitHub: [@omar-khaium](https://github.com/omar-khaium)

**Do not** create public issues for security vulnerabilities.

---

## Core Features

- **Emergency SOS Button** - One-tap emergency activation
- **Real-time Location Tracking** - GPS-based location with continuous updates
- **Emergency Contacts** - Automatic SMS/push notification system
- **Nearby Responders** - Find police stations, hospitals, fire services
- **Settings & Preferences** - Customizable emergency response options

---

## API Documentation

API documentation is available via Swagger UI:
- Development: `https://localhost:5001/swagger`
- Production: Check README for latest deployed URL

---

## Firebase App Distribution

### For Testers

1. Contact [@omar-khaium](https://github.com/omar-khaium) for access
2. Receive invitation email from Firebase
3. Install Firebase App Tester from Play Store
4. Accept invitation and install Shongkot
5. Enable notifications for update alerts

### Features

✅ **Automatic Updates** - No manual APK download for existing users
✅ **Version Check** - App automatically checks for newer versions
✅ **Push Notifications** - Testers notified when new builds available
✅ **Rollback Support** - Can revert to previous versions if needed
✅ **Distribution Groups** - Organized tester groups (alpha, beta, production)

---

## License

This project is licensed under the Shongkot Proprietary License 1.0 - see the [LICENSE](../LICENSE) file for details.

**Copyright © 2025 Omar Khaium. All Rights Reserved.**

---

## Contact

For licensing inquiries or access requests:
- GitHub: [@omar-khaium](https://github.com/omar-khaium)

---

**⚠️ CONFIDENTIAL**: This repository and its contents are proprietary and confidential. Unauthorized access, use, or distribution is prohibited.
