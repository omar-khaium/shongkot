# Shongkot - Emergency Responder

[![Backend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml)
[![Frontend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml)
[![codecov](https://codecov.io/gh/omar-khaium/shongkot/branch/main/graph/badge.svg)](https://codecov.io/gh/omar-khaium/shongkot)

## 🚀 Latest Deployment

**Version:** v2025.11.13-740958f  
**Deployed:** 2025-11-13 09:49:40 UTC  
**Commit:** 740958f

### Service Status

- **Health Check:** ✅ healthy - [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/health](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/health)
- **API Documentation:** ✅ available - [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/swagger](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/swagger)
- **Base URL:** [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app)

### What's New in v2025.11.13-740958f

Merge cde715f9cf6bc0b4ff7c24c45f3ecaa640a8f756 into e09cce5ee0ac539aa3f1b94ed95d0b1354c1274b

### Recent Changes

- Merge cde715f9cf6bc0b4ff7c24c45f3ecaa640a8f756 into e09cce5ee0ac539aa3f1b94ed95d0b1354c1274b (740958f)
- Add git pull --rebase before push to prevent non-fast-forward errors (cde715f)
- docs: update README with deployment info [v2025.11.12-e5098bb] (6e92967)
- Merge 6486c49a5424142467803471194010c1bf7389cc into e09cce5ee0ac539aa3f1b94ed95d0b1354c1274b (e5098bb)
- Fix deployment URL masking by using base64 encoding (6486c49)
- Initial plan (ee10208)
- docs: update README with deployment info [v2025.11.12-cd15803] (e09cce5)
- Merge pull request #2 from omar-khaium/copilot/deploy-project-to-cicd (cd15803)
- docs: update README with deployment info [v2025.11.12-5da5315] (ebc25ae)
- Merge cfc73a0cab2bae77f0ad5b3c29daef83a8170f74 into 66d5bfe64dbb516d01c9326775be045d1036944b (5da5315)

---





**⚠️ PROPRIETARY SOFTWARE - All Rights Reserved**

Copyright © 2025 Omar Khaium

This is proprietary and confidential software. Unauthorized copying, distribution, or use of this software is strictly prohibited. See [LICENSE](LICENSE) for details.

---

## Overview

**Shongkot** is a proprietary emergency responder mobile application that simplifies emergency response coordination. When someone faces an emergency (accident, health crisis, fire, assault, etc.), they often lose valuable minutes trying to reach the right service. Shongkot solves this problem:

- **One button** connects users to nearby responders
- **Live location** sharing in real-time
- **Automatic alerts** to family and friends
- **Quick access** to emergency services

## 📁 Repository Structure

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
│   └── CONTRIBUTING.md        # Contribution guidelines
│
├── .github/                   # GitHub Actions workflows
│   └── workflows/
│       ├── backend-cicd.yml   # Backend CI/CD
│       └── frontend-cicd.yml  # Frontend CI/CD
│
├── .gitignore                 # Git ignore rules
├── README.md                  # This file
└── LICENSE                    # Shongkot Proprietary License 1.0
```

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
mobile/
├── lib/
│   ├── core/                  # Core utilities, theme, constants
│   ├── features/              # Feature modules (Emergency, Contacts, Settings)
│   │   └── {feature}/
│   │       ├── data/          # Data layer (models, repositories, datasources)
│   │       ├── domain/        # Domain layer (entities, use cases)
│   │       └── presentation/  # UI layer (pages, widgets, bloc)
│   └── main.dart
├── test/                      # Unit and widget tests
└── integration_test/          # Integration tests
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

For detailed setup instructions, see [docs/SETUP.md](docs/SETUP.md).

## 🧪 Testing

### Backend Tests

```bash
cd backend
dotnet test
```

### Frontend Tests

```bash
cd mobile
flutter test
```

For more testing details, see [docs/SETUP.md](docs/SETUP.md).

## 📦 CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment:

### Backend Pipeline
- ✅ Build and compile
- ✅ Run unit tests
- ✅ Run integration tests
- ✅ Docker image build and test
- 🚀 Ready for deployment to Render.com (free tier)

### Frontend Pipeline
- ✅ Code analysis and formatting
- ✅ Run unit tests
- ✅ Run widget tests
- ✅ Run integration tests
- 🔨 Build APK and AAB
- 🚀 Deploy to Firebase App Distribution

## 🌐 Backend Deployment

The backend API can be deployed to Render.com's free tier:

### Quick Deploy
1. Sign up at [Render.com](https://render.com)
2. Connect this GitHub repository
3. Deploy using the `render.yaml` blueprint
4. Get your public API URL: `https://shongkot-api.onrender.com`

### Available Endpoints
- **Health Check**: `/health` - Service status
- **Swagger UI**: `/swagger` - Interactive API documentation
- **Emergency API**: `/api/emergency/*` - Emergency endpoints
- **Contacts API**: `/api/contacts/*` - Emergency contacts

For detailed deployment instructions, see [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md).

## 🔑 Core Features

- **Emergency SOS Button** - One-tap emergency activation
- **Real-time Location Tracking** - GPS-based location with continuous updates
- **Emergency Contacts** - Automatic SMS/push notification system
- **Nearby Responders** - Find police stations, hospitals, fire services
- **Settings & Preferences** - Customizable emergency response options

## 🔐 Security

- All API endpoints use HTTPS
- Input validation and sanitization
- Rate limiting on critical endpoints
- Security scanning in CI/CD pipeline
- Regular dependency updates

## 📊 API Documentation

API documentation is available via Swagger UI when running the backend:
- Development: `https://localhost:5001/swagger`
- Production (Render.com): `https://shongkot-api.onrender.com/swagger`

See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) for deployment instructions.

## 📱 Firebase App Distribution

Test builds are distributed to authorized testers via Firebase App Distribution with **automatic in-app updates enabled**.

### Download Latest Build

**For Authorized Testers:**
- 🔗 [Download Latest APK from Firebase App Distribution](https://appdistribution.firebase.google.com/testerapps/YOUR_FIREBASE_APP_ID)
- 📱 Download the **Firebase App Tester** app from Play Store
- ✅ Accept the invitation email from Firebase
- 🔄 **In-app updates**: Automatic update notifications for new releases

### Latest Release

Check the [Releases page](../../releases/latest) for the latest builds with:
- 📦 APK files (ready to install)
- 📦 AAB files (for Play Store)
- 📝 Detailed release notes
- 🔢 Build information

### How It Works

1. **New Build Created**: Every merge to `main` or `develop` triggers a build
2. **Firebase Distribution**: APK is automatically uploaded to Firebase
3. **Tester Notification**: Authorized testers receive push notifications
4. **In-App Update**: Existing users see update prompt inside the app
5. **Automatic Install**: Users can update with one tap

### Features

✅ **Automatic Updates** - No manual APK download for existing users
✅ **Version Check** - App automatically checks for newer versions
✅ **Push Notifications** - Testers notified when new builds are available
✅ **Rollback Support** - Can revert to previous versions if needed
✅ **Distribution Groups** - Organized tester groups (alpha, beta, production)

### Getting Tester Access

To become a tester and receive automatic updates:

1. Contact [@omar-khaium](https://github.com/omar-khaium) for access
2. Receive invitation email from Firebase
3. Install Firebase App Tester from Play Store
4. Accept the invitation and install Shongkot
5. Enable notifications to receive update alerts

**Note:** This is proprietary software. Tester access is restricted and requires authorization.

## 📄 License

This project is licensed under the Shongkot Proprietary License 1.0 - see the [LICENSE](LICENSE) file for details.

**Copyright © 2025 Omar Khaium. All Rights Reserved.**

## 👥 Author

**Omar Khaium** - *Project Owner* - [@omar-khaium](https://github.com/omar-khaium)

## 📞 Contact

For licensing inquiries or access requests, contact:
- GitHub: [@omar-khaium](https://github.com/omar-khaium)

---

**⚠️ CONFIDENTIAL**: This repository and its contents are proprietary and confidential. Unauthorized access, use, or distribution is prohibited.
