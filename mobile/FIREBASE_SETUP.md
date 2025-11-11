# Firebase App Distribution Setup Guide

This guide explains how to set up Firebase App Distribution with in-app updates for the Shongkot Emergency Responder app.

## Overview

Firebase App Distribution provides:
- **Automatic app distribution** to testers
- **In-app update prompts** for existing users
- **Push notifications** when new builds are available
- **Version tracking** and rollback support
- **Tester management** with groups

## Prerequisites

- Firebase project created
- Firebase CLI installed: `npm install -g firebase-tools`
- Service account credentials with App Distribution permissions
- Android app registered in Firebase

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: **shongkot-emergency-responder**
4. Enable Google Analytics (optional)
5. Complete project creation

## Step 2: Register Android App

1. In Firebase Console, click "Add app" → Android
2. Enter package name: `com.omar_khaium.shongkot`
3. Download `google-services.json`
4. Place it in `mobile/android/app/`
5. Add to `.gitignore` (already configured)

## Step 3: Enable App Distribution

1. In Firebase Console, navigate to **Release & Monitor** → **App Distribution**
2. Click "Get Started"
3. Accept terms of service
4. Note your Firebase App ID (format: `1:123456789:android:abc123...`)

## Step 4: Create Service Account

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click "Generate New Private Key"
3. Save the JSON file securely
4. This file contains credentials for CI/CD automation

## Step 5: Configure GitHub Secrets

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

### Required Secrets

| Secret Name | Description | How to Get |
|------------|-------------|------------|
| `FIREBASE_APP_ID` | Firebase Android App ID | Firebase Console → Project Settings → Your Apps |
| `FIREBASE_SERVICE_CREDENTIALS` | Service account JSON | Firebase Console → Service Accounts → Generate Private Key |

### Example: Getting Firebase App ID

```bash
# From Firebase Console
Project Settings → Your Apps → Android App → App ID
Format: 1:123456789012:android:abc123def456...
```

### Example: Service Account JSON

```json
{
  "type": "service_account",
  "project_id": "shongkot-emergency-responder",
  "private_key_id": "abc123...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-xxxxx@project.iam.gserviceaccount.com",
  "client_id": "123456789",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  ...
}
```

**Add this entire JSON as the `FIREBASE_SERVICE_CREDENTIALS` secret (minified, no line breaks).**

## Step 6: Add Testers

### Via Firebase Console

1. Go to App Distribution → Testers & Groups
2. Click "Add Testers"
3. Enter email addresses
4. Assign to group: **testers** (default)
5. Send invitations

### Via Firebase CLI

```bash
# Login to Firebase
firebase login

# Add testers
firebase appdistribution:testers:add tester1@example.com tester2@example.com \
  --project shongkot-emergency-responder \
  --app 1:123456789012:android:abc123def456

# Create group
firebase appdistribution:group:create testers \
  --project shongkot-emergency-responder

# Add testers to group
firebase appdistribution:group:add-testers testers tester1@example.com tester2@example.com \
  --project shongkot-emergency-responder \
  --app 1:123456789012:android:abc123def456
```

## Step 7: Configure In-App Updates

The app is already configured with Firebase dependencies in `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_app_check: ^0.2.1+9
```

### Initialize Firebase in App

Create `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: '1:123456789012:android:abc123def456',
    messagingSenderId: '123456789012',
    projectId: 'shongkot-emergency-responder',
    storageBucket: 'shongkot-emergency-responder.appspot.com',
  );
}
```

Update `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

## Step 8: How It Works

### CI/CD Workflow

```yaml
- Build APK/AAB
- Upload to Firebase App Distribution
- Send notifications to testers group
- Generate release notes
- Create GitHub Release
- Save distribution info
```

### In-App Update Flow

1. **App Launch**: Check current version
2. **Version Check**: Query Firebase for latest version
3. **Update Available**: Show prompt to user
4. **User Accepts**: Download and install update
5. **Installation**: App restarts with new version

### Firebase App Tester

Testers should install **Firebase App Tester** from Play Store:

1. Open Play Store
2. Search "Firebase App Tester"
3. Install the app
4. Accept invitation from email
5. See Shongkot in the app list
6. Enable notifications for update alerts

## Step 9: Testing Distribution

### Manual Upload (Testing)

```bash
cd mobile

# Build release APK
flutter build apk --release

# Upload to Firebase
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app 1:123456789012:android:abc123def456 \
  --groups testers \
  --release-notes "Test build for Firebase distribution"
```

### Automated (CI/CD)

Push to `main` or `develop` branch:

```bash
git push origin main
```

GitHub Actions will automatically:
1. Build the app
2. Upload to Firebase
3. Notify testers
4. Create release

## Step 10: Verify Setup

### Check Distribution

1. Go to Firebase Console → App Distribution
2. See list of releases
3. Verify testers received notifications
4. Check download counts

### Check In-App Updates

1. Install app from Firebase App Tester
2. Push a new build to main
3. Open the app
4. Verify update prompt appears
5. Accept update
6. Verify new version installed

## Troubleshooting

### Issue: Testers not receiving invitations

**Solution:**
- Check email addresses are correct
- Look in spam folder
- Re-send invitation from Firebase Console
- Verify Firebase App Distribution is enabled

### Issue: In-app updates not working

**Solution:**
- Verify `google-services.json` is in `android/app/`
- Check Firebase is initialized in `main.dart`
- Ensure Firebase Core dependency is added
- Verify app version is incremented

### Issue: CI/CD upload fails

**Solution:**
- Verify `FIREBASE_APP_ID` secret is correct
- Check `FIREBASE_SERVICE_CREDENTIALS` JSON format
- Ensure service account has App Distribution permissions
- Check Firebase project ID matches

## Security Best Practices

1. **Never commit** `google-services.json` to repository
2. **Secure GitHub Secrets** - only repository admins should access
3. **Rotate service account keys** periodically
4. **Limit tester groups** to authorized personnel only
5. **Monitor distribution** for unauthorized access
6. **Use release groups** for staged rollouts

## Links

- [Firebase Console](https://console.firebase.google.com/)
- [Firebase App Distribution Docs](https://firebase.google.com/docs/app-distribution)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)
- [GitHub Actions Workflow](.github/workflows/frontend-cicd.yml)

## Support

For issues or questions:
- Repository Owner: [@omar-khaium](https://github.com/omar-khaium)
- Firebase Documentation: https://firebase.google.com/support

---

**⚠️ PROPRIETARY SOFTWARE** - This setup is for authorized personnel only.

Copyright © 2025 Omar Khaium. All Rights Reserved.
