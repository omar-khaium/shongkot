# Setup Guide

## Backend Setup (ASP.NET Core)

### Prerequisites
- .NET 9.0 SDK or later
- Visual Studio 2022, VS Code, or Rider
- SQL Server (optional, for production)

### Initial Setup

1. **Clone the repository:**
```bash
git clone https://github.com/omar-khaium/shongkot.git
cd shongkot
```

2. **Navigate to backend:**
```bash
cd backend
```

3. **Restore NuGet packages:**
```bash
dotnet restore
```

4. **Build the solution:**
```bash
dotnet build --configuration Release
```

5. **Run the API:**
```bash
cd Shongkot.Api
dotnet run
```

The API will start on `https://localhost:5001` (or check console output for the port).

6. **Access Swagger UI:**
Open your browser and navigate to:
```
https://localhost:5001/swagger
```

### Running Tests

```bash
# From backend directory
dotnet test

# With coverage
dotnet test --collect:"XPlat Code Coverage"

# Specific project
dotnet test Shongkot.Api.Tests/
```

### Database Setup (Future)

Currently, the API uses in-memory storage. For production:

1. Update `appsettings.json` with connection string
2. Run migrations: `dotnet ef database update`
3. Seed initial data if needed

---

## Frontend Setup (Flutter)

### Prerequisites
- Flutter SDK 3.19 or later
- Dart 3.0 or later
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS development, macOS only)
- Firebase account

### Initial Setup

1. **Install Flutter:**
Follow the official guide: https://flutter.dev/docs/get-started/install

2. **Verify installation:**
```bash
flutter doctor
```

3. **Navigate to frontend:**
```bash
cd frontend/shongkot_app
```

4. **Install dependencies:**
```bash
flutter pub get
```

5. **Firebase Configuration:**

**For Android:**
- Go to Firebase Console
- Create a new project
- Add Android app
- Download `google-services.json`
- Place it in `android/app/`

**For iOS:**
- Add iOS app in Firebase Console
- Download `GoogleService-Info.plist`
- Place it in `ios/Runner/`

6. **Run the app:**
```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For web
flutter run -d chrome
```

### Running Tests

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget

# Integration tests (requires emulator/device)
flutter drive --target=test_driver/app.dart

# With coverage
flutter test --coverage
```

### Build for Production

**Android:**
```bash
# APK
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "Shongkot"
4. Enable Google Analytics (optional)
5. Create project

### 2. Enable Services

**Cloud Messaging (for notifications):**
1. In Firebase Console, go to Project Settings
2. Cloud Messaging tab
3. Note the Server Key and Sender ID

**App Distribution:**
1. In Firebase Console, go to App Distribution
2. Add testers
3. Create tester groups

**Crashlytics (optional):**
1. Enable Crashlytics in Firebase Console
2. Follow setup instructions

### 3. Download Configuration Files

- Download `google-services.json` (Android)
- Download `GoogleService-Info.plist` (iOS)
- Place them in the appropriate directories (see above)

---

## Azure Deployment (Backend)

### Prerequisites
- Azure subscription
- Azure CLI installed

### Steps

1. **Login to Azure:**
```bash
az login
```

2. **Create Resource Group:**
```bash
az group create --name shongkot-rg --location eastus
```

3. **Create App Service Plan:**
```bash
az appservice plan create --name shongkot-plan --resource-group shongkot-rg --sku B1 --is-linux
```

4. **Create Web App:**
```bash
az webapp create --name shongkot-api --resource-group shongkot-rg --plan shongkot-plan --runtime "DOTNET|9.0"
```

5. **Configure GitHub Actions:**
   - Go to GitHub repository settings
   - Add secrets:
     - `AZURE_WEBAPP_NAME`: Your web app name
     - `AZURE_WEBAPP_PUBLISH_PROFILE`: Download from Azure portal

6. **Deploy:**
Push to main branch, and GitHub Actions will automatically deploy.

### Access Deployed API
```
https://your-app-name.azurewebsites.net/swagger
```

---

## CI/CD Configuration

### GitHub Secrets Required

**Backend (Azure):**
- `AZURE_WEBAPP_NAME`: Azure Web App name
- `AZURE_WEBAPP_PUBLISH_PROFILE`: Publish profile from Azure

**Frontend (Firebase):**
- `FIREBASE_APP_ID`: Firebase App ID
- `FIREBASE_SERVICE_CREDENTIALS`: Service account JSON

### Adding Secrets

1. Go to GitHub repository
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add each secret with its value

---

## Development Workflow

### 1. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
```

### 2. Make Changes and Test
```bash
# Backend
cd backend
dotnet test

# Frontend
cd frontend/shongkot_app
flutter test
```

### 3. Commit and Push
```bash
git add .
git commit -m "feat: your feature description"
git push origin feature/your-feature-name
```

### 4. Create Pull Request
- GitHub Actions will automatically:
  - Run all tests
  - Check code coverage
  - Run security scans
  - Build artifacts

### 5. Review and Merge
- Wait for CI/CD checks to pass
- Get code review approval
- Merge to main
- Automatic deployment will trigger

---

## Troubleshooting

### Backend Issues

**Port already in use:**
```bash
# Change port in launchSettings.json or use:
dotnet run --urls "https://localhost:5002"
```

**Package restore fails:**
```bash
# Clear NuGet cache
dotnet nuget locals all --clear
dotnet restore
```

### Frontend Issues

**Flutter doctor issues:**
```bash
# Run and follow suggestions
flutter doctor -v
```

**Dependency conflicts:**
```bash
flutter clean
flutter pub get
```

**Android build fails:**
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

**iOS build fails:**
```bash
cd ios
pod install
cd ..
flutter build ios
```

---

## Next Steps

1. Configure environment variables
2. Set up monitoring and logging
3. Configure SSL certificates
4. Set up database backups
5. Configure CDN for static assets
6. Set up application insights

For more information, see the main [README.md](../README.md).
