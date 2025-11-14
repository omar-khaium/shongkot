# Shongkot - Emergency Responder

[![Backend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml)
[![Frontend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml)
[![codecov](https://codecov.io/gh/omar-khaium/shongkot/branch/main/graph/badge.svg)](https://codecov.io/gh/omar-khaium/shongkot)

## 🚀 Latest Deployment

**Version:** v2025.11.14-7d9fec2  
**Deployed:** 2025-11-14 10:19:19 UTC  
**Commit:** 7d9fec2

### Service Status

- **Health Check:** ✅ healthy - [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/health](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/health)
- **API Documentation:** ✅ available - [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/swagger](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/swagger)
- **Base URL:** [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app)

### What's New in v2025.11.14-7d9fec2

Merge pull request #20 from omar-khaium/mobile

Mobile

### Recent Changes

- Merge pull request #20 from omar-khaium/mobile (7d9fec2)
- Merge pull request #19 from omar-khaium/copilot/fix-dart-format-issues (da02b22)
- Fix Dart formatting after flutter pub get (CI compatibility) (ae15108)
- Add pre-commit hooks to enforce code quality checks locally (431af99)
- Fix Dart formatting issues in mobile app files (e447b1d)
- Initial plan (539dfb4)
- Merge pull request #17 from omar-khaium/copilot/fix-theme-change-bug (5417f4c)
- Fix theme change not taking effect immediately (062cd17)
- Initial plan (369dd39)
- Merge pull request #12 from omar-khaium/copilot/fix-release-date-output (6268290)

---




## 📱 Latest Mobile App Version

**Version:** v1.0.0-build.1  
**Release Date:** N/A  
**Platform:** Android (iOS coming soon)  
**Distribution:** Firebase App Distribution

### Download Links

- **Firebase App Distribution:** [Download Latest APK](https://appdistribution.firebase.google.com/testerapps/1:657665364433:android:33fc8763de2c42867390f0) (Public - anyone with the link)
- **GitHub Releases:** [v1.0.0-build.1](https://github.com/omar-khaium/shongkot/releases/latest)

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

For comprehensive documentation, please visit:

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
