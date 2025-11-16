# Shongkot - Emergency Responder

[![Backend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml)
[![Frontend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml)
[![codecov](https://codecov.io/gh/omar-khaium/shongkot/branch/main/graph/badge.svg)](https://codecov.io/gh/omar-khaium/shongkot)

## 🚀 Latest Deployment

**Version:** v2025.11.16-8736dbf  
**Deployed:** 2025-11-16 13:15:03 UTC  
**Commit:** 8736dbf

### Service Status

- **Health Check:** ✅ healthy - [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/health](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/health)
- **API Documentation:** ✅ available - [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/swagger](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/swagger)
- **Base URL:** [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app)

### What's New in v2025.11.16-8736dbf

Merge pull request #43 from omar-khaium/mobile

Mobile

### Recent Changes

- Merge pull request #43 from omar-khaium/mobile (8736dbf)
- Merge pull request #44 from omar-khaium/copilot/sub-pr-43 (91414c4)
- Fix C# syntax error in AuthController by merging duplicate class members (cf94e29)
- Initial plan (fe770bf)
- Merge pull request #40 from omar-khaium/copilot/implement-biometric-login (68d822b)
- Implement biometric login functionality and enhance authentication flow (2d28a8d)
- Fix merge conflicts: remove duplicate User and FakeAuthRepository classes, add localized password validation (fe577bd)
- Merge branch 'mobile' into copilot/implement-biometric-login (605ebb4)
- Merge pull request #42 from omar-khaium/copilot/create-emergency-history-screen (546dca0)
- Merge branch 'mobile' into copilot/create-emergency-history-screen (f4f6a81)

---



<<<<<<< HEAD
## 📱 Latest Mobile App Version

**Version:** v1.0.0-build.167  
**Release Date:** 2025-11-16  
**Platform:** Android (iOS coming soon)  
**Distribution:** Firebase App Distribution

### Download Links

- **Firebase App Distribution:** [Download Latest APK](https://appdistribution.firebase.google.com/testerapps/1:657665364433:android:33fc8763de2c42867390f0) (Public - anyone with the link)
- **GitHub Releases:** [v1.0.0-build.167](https://github.com/omar-khaium/shongkot/releases/tag/v1.0.0-build.167)

### In-App Updates

✅ **Automatic Updates Enabled**
- Users with previous versions will receive update prompts
- Updates are delivered through Firebase App Distribution
- No manual download required for existing users

### Features

- Emergency SOS button with one-tap activation
- Real-time GPS location tracking
- Automatic emergency contact notifications
- Nearby responders finder

---

## 📱 Latest Mobile App Version

**Version:** v1.0.0-build.167  
**Release Date:** 2025-11-16  
**Platform:** Android (iOS coming soon)  
**Distribution:** Firebase App Distribution

### Download Links

- **Firebase App Distribution:** [Download Latest APK](https://appdistribution.firebase.google.com/testerapps/1:657665364433:android:33fc8763de2c42867390f0) (Public - anyone with the link)
- **GitHub Releases:** [v1.0.0-build.167](https://github.com/omar-khaium/shongkot/releases/tag/v1.0.0-build.167)

### In-App Updates

✅ **Automatic Updates Enabled**
- Users with previous versions will receive update prompts
- Updates are delivered through Firebase App Distribution
- No manual download required for existing users

### Features

- Emergency SOS button with one-tap activation
- Real-time GPS location tracking
- Automatic emergency contact notifications
- Nearby responders finder

---



## 📚 Documentation

### 🚀 Mobile App Development
- **[Quick Start Guide](QUICK_START.md)** - Get started developing the mobile app
- **[Development Plan](MOBILE_APP_DEVELOPMENT_PLAN.md)** - Complete 6-month development roadmap
- **[GitHub Projects Setup](GITHUB_PROJECTS_SETUP.md)** - How to use GitHub Projects for task management
- **[Mobile App README](mobile/README.md)** - Mobile-specific documentation
- **[Design System](mobile/DESIGN_SYSTEM.md)** - UI/UX design guidelines
- **[Component Guide](mobile/COMPONENT_GUIDE.md)** - Reusable component documentation

### 📖 General Documentation
- **[Complete Wiki](docs/WIKI.md)** - Full documentation including architecture, setup, deployment
- **[Branch Strategy](docs/BRANCH_STRATEGY.md)** - Development workflow and branch management
- **[Architecture](docs/ARCHITECTURE.md)** - System architecture and design
- **[Setup Guide](docs/SETUP.md)** - Detailed setup instructions
- **[Deployment Guide](docs/DEPLOYMENT.md)** - Deployment instructions
- **[Contributing](docs/CONTRIBUTING.md)** - Contribution guidelines

## 🏗️ Quick Start

**First Time Setup (Required):**
```bash
# Clone the repository
git clone https://github.com/omar-khaium/shongkot.git
cd shongkot

# Run setup script to configure git hooks
./setup-dev.sh
```

This setup script configures pre-commit hooks that automatically:
- ✅ Check code formatting before commits
- ✅ Run lint checks to catch errors early
- ✅ Prevent commits with code quality issues
- ✅ Ensure CI/CD doesn't fail due to formatting/lint errors

**Backend:**
```bash
cd backend
dotnet restore
dotnet build
dotnet run --project Shongkot.Api
# Access API at https://localhost:5001/swagger
```

**Mobile:**
```bash
cd mobile
flutter pub get
flutter run
```

## 🌳 Branch Structure

- **`main`** - Production-ready stable version
- **`mobile`** - Latest stable mobile application code
- **`backend`** - Latest stable backend API code

**Development Workflow:**
- Mobile features → `mobile` branch → `main`
- Backend features → `backend` branch → `main`

See [Branch Strategy](docs/BRANCH_STRATEGY.md) for detailed workflow.

---

## 🎯 Development Roadmap

We're actively developing the mobile app following a comprehensive 6-month roadmap:

**Current Phase**: Phase 1 - Foundation & Core Features (Weeks 1-4)

### Development Phases
1. **Phase 1**: Authentication, Location Services, API Integration
2. **Phase 2**: Push Notifications, Messaging, Contacts Management
3. **Phase 3**: Responder Discovery, Interaction, Tracking
4. **Phase 4**: Interactive Maps, Navigation, Geofencing
5. **Phase 5**: Media Capture, Evidence Documentation
6. **Phase 6**: Advanced Safety & Social Features
7. **Phase 7**: iOS Support, Performance, Accessibility
8. **Phase 8**: Testing, Beta Program, Production Launch

**📋 View the complete plan**: [MOBILE_APP_DEVELOPMENT_PLAN.md](MOBILE_APP_DEVELOPMENT_PLAN.md)  
**🚀 Get started developing**: [QUICK_START.md](QUICK_START.md)  
**📊 Track progress**: [GitHub Projects](https://github.com/omar-khaium/shongkot/projects)

---

## Overview

**Shongkot** is a proprietary emergency responder mobile application that simplifies emergency response coordination. When someone faces an emergency, they often lose valuable minutes trying to reach the right service. Shongkot solves this with one-button access to nearby responders, live location sharing, and automatic alerts to emergency contacts.

---

## 📄 License

This project is licensed under the Shongkot Proprietary License 1.0 - see the [LICENSE](LICENSE) file for details.

**Copyright © 2025 Omar Khaium. All Rights Reserved.**

## 👥 Author

**Omar Khaium** - *Project Owner* - [@omar-khaium](https://github.com/omar-khaium)

## 📞 Contact

For licensing inquiries or access requests, contact:
- GitHub: [@omar-khaium](https://github.com/omar-khaium)

---

**⚠️ PROPRIETARY SOFTWARE - All Rights Reserved**

This is proprietary and confidential software. Unauthorized copying, distribution, or use of this software is strictly prohibited.
