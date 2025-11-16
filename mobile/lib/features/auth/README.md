# Authentication Feature Documentation

## Overview
This feature provides login functionality with email/phone and password authentication, plus biometric login support (fingerprint/face recognition).

## Features
- ✅ Login form with email/phone and password fields
- ✅ Password visibility toggle
- ✅ "Remember me" option
- ✅ Biometric authentication (fingerprint/face)
- ✅ Secure credential storage using Flutter Secure Storage
- ✅ Loading states during authentication
- ✅ Error handling for invalid credentials
- ✅ Logout functionality
- ✅ Biometric fallback to password if authentication fails
- ✅ Multi-language support (English and Bengali)

## Architecture

### Domain Layer
- **User**: Model representing an authenticated user
- **LoginCredentials**: Model for login credentials
- **AuthRepository**: Abstract interface for authentication operations

### Data Layer
- **FakeAuthRepository**: Fake implementation for testing and development
- **SecureStorageService**: Service for securely storing sensitive data
- **BiometricService**: Service for handling biometric authentication

### Presentation Layer
- **LoginScreen**: Main login screen UI
- **AuthNotifier**: State management for authentication
- **AuthState**: Authentication state model
- **AuthWrapper**: Widget that handles authentication state routing

## Usage

### Test Credentials
For the fake implementation, you can use any email/phone and password except:
- Password: "wrong" - will throw an error
- Empty fields - will throw validation errors

### Biometric Login
1. Login with password first and enable "Remember me"
2. This saves your credentials securely
3. Next time, use the "Login with Biometric" button
4. Authenticate with your fingerprint or face
5. Automatic login using saved credentials

### Logout
- Navigate to Settings screen
- Tap on "Logout"
- Confirm logout in the dialog

## API Integration (Future)

The fake repository can be replaced with a real implementation that calls these endpoints:

### POST /api/auth/login
Request:
```json
{
  "emailOrPhone": "user@example.com",
  "password": "password123",
  "rememberMe": true
}
```

Response:
```json
{
  "id": "user-123",
  "email": "user@example.com",
  "phone": "+8801234567890",
  "name": "User Name",
  "photoUrl": null,
  "token": "jwt-token",
  "refreshToken": "refresh-token"
}
```

### POST /api/auth/refresh
Request:
```json
{
  "refreshToken": "refresh-token"
}
```

Response:
```json
{
  "id": "user-123",
  "email": "user@example.com",
  "phone": "+8801234567890",
  "name": "User Name",
  "photoUrl": null,
  "token": "new-jwt-token",
  "refreshToken": "new-refresh-token"
}
```

## Security Considerations

1. **Secure Storage**: Credentials are stored using Flutter Secure Storage which uses:
   - Android: Keystore
   - iOS: Keychain

2. **Biometric Authentication**: 
   - Only available if device supports it
   - Requires saved credentials
   - Uses local_auth package for platform-specific biometric APIs

3. **Token Management**:
   - JWT tokens are stored securely
   - Refresh token mechanism for session management
   - Automatic logout clears all stored credentials

## Testing

### Unit Tests
- `test/unit/features/auth/fake_auth_repository_test.dart`
  - Tests for login, logout, credential management, and token refresh

### Widget Tests
- `test/widget/features/auth/login_screen_test.dart`
  - Tests for UI components and user interactions
  - Form validation tests
  - Password visibility toggle test
  - Remember me checkbox test

Run tests:
```bash
cd mobile
flutter test
```

## Localization

Strings are available in:
- English: `lib/l10n/app_en.arb`
- Bengali: `lib/l10n/app_bn.arb`

New strings added:
- login, loginTitle, loginSubtitle
- emailOrPhone, password, rememberMe
- forgotPassword, loginWithBiometric
- biometricReason, noBiometricCredentials
- biometricNotAvailable, loginError
- invalidCredentials, fieldRequired, invalidEmail

## Platform Requirements

### Android
- minSdkVersion: 21 (Android 5.0)
- Permissions in AndroidManifest.xml:
  - `USE_BIOMETRIC` - for biometric authentication

### iOS (Future)
- Info.plist will need:
  - `NSFaceIDUsageDescription` - Face ID usage description

## Dependencies

Added to `pubspec.yaml`:
```yaml
dependencies:
  flutter_secure_storage: ^9.2.2
  local_auth: ^2.3.0
```

## Future Enhancements

1. Implement real API integration
2. Add "Forgot Password" flow
3. Add social login (Google, Facebook)
4. Add email verification
5. Add two-factor authentication
6. Add biometric re-authentication for sensitive actions
7. Add session timeout management
8. Add device management (trusted devices)

## Notes

- Currently using fake implementation for development
- Real API implementation should extend AuthRepository interface
- Biometric authentication requires physical device for testing
- Emulators may not support all biometric features
