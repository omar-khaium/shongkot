# Shongkot - Emergency Responder

[![Backend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml)
[![Frontend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml)
[![codecov](https://codecov.io/gh/omar-khaium/shongkot/branch/main/graph/badge.svg)](https://codecov.io/gh/omar-khaium/shongkot)

## Overview

**Shongkot** is an emergency responder mobile application that simplifies emergency response coordination. When someone faces an emergency (accident, health crisis, fire, assault, etc.), they often lose valuable minutes trying to reach the right service. Shongkot solves this problem:

- **One button** connects users to nearby responders
- **Live location** sharing in real-time
- **Automatic alerts** to family and friends
- **Quick access** to emergency services

## 🏗️ Architecture

This project follows Clean Architecture principles with a clear separation of concerns:

### Backend (ASP.NET Core API)
```
backend/
├── Shongkot.Api/              # Web API layer (Controllers, Middleware)
├── Shongkot.Application/      # Application logic (Services, DTOs)
├── Shongkot.Domain/           # Domain entities and interfaces
├── Shongkot.Infrastructure/   # External concerns (Database, External APIs)
└── Tests/
    ├── Shongkot.Api.Tests/
    ├── Shongkot.Application.Tests/
    └── Shongkot.Integration.Tests/
```

### Frontend (Flutter)
```
frontend/shongkot_app/
├── lib/
│   ├── core/                  # Core utilities, theme, constants
│   ├── features/              # Feature modules (Emergency, Contacts, Settings)
│   │   └── {feature}/
│   │       ├── data/          # Data layer (models, repositories, datasources)
│   │       ├── domain/        # Domain layer (entities, use cases)
│   │       └── presentation/  # UI layer (pages, widgets, bloc)
│   └── main.dart
├── test/                      # Unit and widget tests
├── integration_test/          # Integration tests
└── test_driver/               # E2E tests
```

## 🚀 Getting Started

### Prerequisites

**Backend:**
- [.NET 9.0 SDK](https://dotnet.microsoft.com/download)
- Visual Studio 2022+ or VS Code with C# extension

**Frontend:**
- [Flutter 3.19+](https://flutter.dev/docs/get-started/install)
- Android Studio / Xcode (for mobile development)
- [Firebase account](https://firebase.google.com/) (for notifications)

### Backend Setup

1. **Clone the repository:**
```bash
git clone https://github.com/omar-khaium/shongkot.git
cd shongkot/backend
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

1. **Navigate to frontend directory:**
```bash
cd frontend/shongkot_app
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

## 🧪 Testing

### Backend Tests

```bash
# Run all tests
cd backend
dotnet test

# Run with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run specific test project
dotnet test Shongkot.Api.Tests/
```

### Frontend Tests

```bash
cd frontend/shongkot_app

# Run unit tests
flutter test

# Run widget tests
flutter test test/widget

# Run integration tests
flutter test integration_test

# Run with coverage
flutter test --coverage
```

## 📦 CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment:

### Backend Pipeline
- ✅ Build and compile
- ✅ Run unit tests
- ✅ Run integration tests
- ✅ Code coverage analysis
- ✅ Security scanning
- 🚀 Deploy to Azure Web App (main branch)
- 📊 Swagger UI available at production endpoint

### Frontend Pipeline
- ✅ Code analysis and formatting
- ✅ Run unit tests
- ✅ Run widget tests
- ✅ Run integration tests (iOS simulator)
- 🔨 Build APK and AAB
- 🔨 Build iOS IPA
- 🚀 Deploy to Firebase App Distribution
- 📱 Testers notified automatically

## 🔑 Core Features

### 1. Emergency SOS Button
- Large, prominent button for immediate emergency activation
- Animated pulse effect for visibility
- One-tap activation with confirmation

### 2. Real-time Location Tracking
- GPS-based location detection
- Continuous location updates during emergency
- Reverse geocoding for address display

### 3. Emergency Contacts
- Add/edit/delete emergency contacts
- Priority contact designation
- Automatic SMS/push notification on emergency

### 4. Nearby Responders
- Find police stations, hospitals, fire services
- Distance-based sorting
- Direct call integration

### 5. Settings & Preferences
- Auto-call emergency services
- Location sharing preferences
- Sound and vibration alerts
- Dark mode support

## 🔐 Security

- All API endpoints use HTTPS
- Input validation and sanitization
- Rate limiting on critical endpoints
- Security scanning in CI/CD pipeline
- Regular dependency updates

## 📊 API Documentation

The API documentation is available via Swagger UI when running the backend:
- Development: `https://localhost:5001/swagger`
- Production: `https://your-app.azurewebsites.net/swagger`

### Key Endpoints

- `POST /api/emergency` - Trigger emergency alert
- `GET /api/emergency/{id}` - Get emergency details
- `PATCH /api/emergency/{id}/status` - Update emergency status
- `POST /api/emergency/find-responders` - Find nearby responders
- `GET /api/contacts/user/{userId}` - Get user's contacts
- `POST /api/contacts` - Add emergency contact

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Quality Standards

- Follow C# and Dart style guidelines
- Write unit tests for all business logic
- Maintain > 80% code coverage
- All tests must pass before merging
- Security vulnerabilities must be addressed

## 📱 Firebase App Distribution

Test builds are automatically distributed to testers via Firebase App Distribution:
1. Testers receive email notification
2. Download and install APK from Firebase console
3. Provide feedback through GitHub issues

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Omar Khaium** - *Initial work* - [omar-khaium](https://github.com/omar-khaium)

## 🙏 Acknowledgments

- Emergency services providers
- Open source community
- Flutter and .NET teams