# Shongkot - Emergency Responder

[![Backend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/backend-cicd.yml)
[![Frontend CI/CD](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml/badge.svg)](https://github.com/omar-khaium/shongkot/actions/workflows/frontend-cicd.yml)
[![codecov](https://codecov.io/gh/omar-khaium/shongkot/branch/main/graph/badge.svg)](https://codecov.io/gh/omar-khaium/shongkot)

## 🚀 Latest Deployment

**Version:** v2025.11.13-63fdcd1  
**Deployed:** 2025-11-13 10:38:41 UTC  
**Commit:** 63fdcd1

### Service Status

- **Health Check:** ✅ healthy - [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/health](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/health)
- **API Documentation:** ✅ available - [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/swagger](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app/swagger)
- **Base URL:** [https://shongkot-mumbai-gyeuv4je3q-el.a.run.app](https://shongkot-mumbai-gyeuv4je3q-el.a.run.app)

### What's New in v2025.11.13-63fdcd1

Merge pull request #5 from omar-khaium/copilot/fix-deployment-url-issues

Fix deployment URL masking and push conflicts in CI/CD workflow

### Recent Changes

- Merge pull request #5 from omar-khaium/copilot/fix-deployment-url-issues (63fdcd1)
- docs: update README with deployment info [v2025.11.13-740958f] (fce789b)
- Add git pull --rebase before push to prevent non-fast-forward errors (cde715f)
- docs: update README with deployment info [v2025.11.12-e5098bb] (6e92967)
- Merge 6486c49a5424142467803471194010c1bf7389cc into e09cce5ee0ac539aa3f1b94ed95d0b1354c1274b (e5098bb)
- Fix deployment URL masking by using base64 encoding (6486c49)
- Initial plan (ee10208)
- docs: update README with deployment info [v2025.11.12-cd15803] (e09cce5)
- Merge pull request #2 from omar-khaium/copilot/deploy-project-to-cicd (cd15803)
- docs: update README with deployment info [v2025.11.12-5da5315] (ebc25ae)

---

## 📱 Latest Mobile App Version

**Version:** 1.0.0+latest  
**Platform:** Android (iOS coming soon)  
**Distribution:** Firebase App Distribution

### Download Links

- **For Testers:** [Firebase App Distribution](https://appdistribution.firebase.google.com/) (requires authorization)
- **Latest Release:** [GitHub Releases](https://github.com/omar-khaium/shongkot/releases/latest)

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
