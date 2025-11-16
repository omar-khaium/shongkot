# OAuth2 Authentication Implementation

## Overview
This document describes the OAuth2-style authentication system implemented for the Shongkot mobile app, including JWT token management, automatic refresh, and social login support.

## Architecture

### Components

#### Data Layer
- **AuthApiClient**: HTTP client for authentication API endpoints
- **ApiAuthRepository**: Real implementation using the API (replaces FakeAuthRepository)
- **TokenManager**: Automatic token refresh and expiration handling
- **SecureStorageService**: Secure credential and token storage
- **BiometricService**: Biometric authentication support

#### Domain Layer
- **User**: User model with JWT tokens
- **AuthRepository**: Abstract interface for all auth operations
- **LoginCredentials**: Login form data model

#### Presentation Layer
- **AuthNotifier**: State management with automatic token refresh
- **LoginScreen**: Login UI with social login buttons
- **RegisterScreen**: Registration UI

## Features

### 1. Email/Phone + Password Authentication
- Register with email or phone
- Login with email/phone and password
- BCrypt password hashing on backend
- Session persistence with refresh tokens

### 2. OAuth2 Token Flow
- **Access Token**: Short-lived (15 minutes), used for API calls
- **Refresh Token**: Long-lived (7 days), used to get new access tokens
- Automatic token refresh 2 minutes before expiration
- Token invalidation on password change

### 3. Social Login Support
- Google Sign-In
- Facebook Login
- Apple Sign In (iOS only)
- Automatic account creation on first social login

### 4. Session Management
- Persistent login across app restarts
- Automatic token refresh in background
- Session invalidation on:
  - Manual logout
  - Password change
  - Refresh token expiration

### 5. Security Features
- Secure token storage using platform keychain
- Automatic cleanup on logout
- Token expiration checking
- Biometric authentication for quick login

## API Integration

### Base URL Configuration
Set the API base URL in your configuration:

```dart
const apiBaseUrl = 'https://your-api-domain.com'; // Production
// const apiBaseUrl = 'http://localhost:5003'; // Development
```

### API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/register` | POST | Register new user |
| `/api/auth/login` | POST | Email/phone + password login |
| `/api/auth/refresh` | POST | Refresh access token |
| `/api/auth/logout` | POST | Revoke refresh token |
| `/api/auth/change-password` | POST | Change password |
| `/api/auth/google` | POST | Google login |
| `/api/auth/facebook` | POST | Facebook login |
| `/api/auth/apple` | POST | Apple login |

### Request/Response Examples

#### Register
```json
// Request
{
  "email": "user@example.com",
  "password": "SecurePass123",
  "name": "John Doe",
  "acceptedTerms": true
}

// Response
{
  "userId": "guid",
  "email": "user@example.com",
  "name": "John Doe",
  "accessToken": "eyJ...",
  "refreshToken": "randomString",
  "expiresAt": "2025-11-16T15:00:00Z",
  "tokenType": "Bearer"
}
```

#### Login
```json
// Request
{
  "emailOrPhone": "user@example.com",
  "password": "SecurePass123"
}

// Response (same as register)
```

#### Refresh Token
```json
// Request
{
  "refreshToken": "previousRefreshToken"
}

// Response
{
  "accessToken": "newAccessToken",
  "refreshToken": "newRefreshToken",
  "expiresAt": "2025-11-16T15:00:00Z",
  "tokenType": "Bearer"
}
```

## Usage

### Setup

1. Add dependencies to `pubspec.yaml`:
```yaml
dependencies:
  # Already included
  http: ^1.1.0
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.2.2
  
  # Add for social login
  google_sign_in: ^6.1.5
  flutter_facebook_auth: ^6.0.3
  sign_in_with_apple: ^5.0.0  # iOS only
```

2. Configure the API client:
```dart
final apiClient = AuthApiClient(
  baseUrl: 'https://your-api-domain.com',
);

final authRepository = ApiAuthRepository(
  apiClient: apiClient,
);
```

3. Update auth provider to use ApiAuthRepository:
```dart
// In auth_repository_provider.dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(
    apiClient: AuthApiClient(baseUrl: apiBaseUrl),
  );
});
```

### Automatic Token Refresh

The TokenManager automatically refreshes tokens 2 minutes before expiration:

```dart
// In AuthNotifier
final tokenManager = TokenManager(
  apiClient: AuthApiClient(baseUrl: apiBaseUrl),
);

// After login
tokenManager.startAutoRefresh(user, expiresAt);

// On logout
tokenManager.stopAutoRefresh();
```

### Social Login Integration

#### Google Sign-In
```dart
import 'package:google_sign_in/google_sign_in.dart';

Future<void> loginWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  try {
    final account = await googleSignIn.signIn();
    if (account == null) return; // User cancelled
    
    final auth = await account.authentication;
    final idToken = auth.idToken;
    
    // Send to backend
    final user = await authRepository.loginWithGoogle(idToken!);
    // Handle successful login
  } catch (e) {
    // Handle error
  }
}
```

#### Facebook Login
```dart
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> loginWithFacebook() async {
  final result = await FacebookAuth.instance.login();
  
  if (result.status == LoginStatus.success) {
    final accessToken = result.accessToken!.token;
    
    // Send to backend
    final user = await authRepository.loginWithFacebook(accessToken);
    // Handle successful login
  }
}
```

#### Apple Sign In
```dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<void> loginWithApple() async {
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );
  
  final identityToken = credential.identityToken;
  
  // Send to backend
  final user = await authRepository.loginWithApple(identityToken!);
  // Handle successful login
}
```

### Session Persistence

Sessions are automatically persisted using secure storage:

```dart
// Check for existing session on app start
final user = await authRepository.getCurrentUser();
if (user != null) {
  // User is logged in, start token refresh
  tokenManager.startAutoRefresh(user, calculateExpiresAt(user.token));
}
```

### Password Change
```dart
Future<void> changePassword(String oldPassword, String newPassword) async {
  final repository = ref.read(authRepositoryProvider) as ApiAuthRepository;
  await repository.changePassword(oldPassword, newPassword);
  
  // User is automatically logged out after password change
  // Redirect to login screen
}
```

## Testing

### Unit Tests
Test files should be created for:
- `auth_api_client_test.dart` - API client tests with mock HTTP
- `api_auth_repository_test.dart` - Repository tests with mock API client
- `token_manager_test.dart` - Token refresh logic tests

### Widget Tests
- `login_screen_test.dart` - Already exists, update for social login buttons
- `register_screen_test.dart` - Registration form tests

### Patrol UI Tests
Create Patrol tests for end-to-end flows:
```dart
// test/integration/auth_flow_test.dart
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('complete login flow', (PatrolTester $) async {
    await $.pumpWidgetAndSettle(const MyApp());
    
    // Enter credentials
    await $(#emailField).enterText('test@example.com');
    await $(#passwordField).enterText('Test123456');
    
    // Tap login button
    await $(#loginButton).tap();
    
    // Verify navigation to home
    expect($(#homeScreen), findsOneWidget);
  });
  
  patrolTest('session persists across app restarts', (PatrolTester $) async {
    // Login
    await $.pumpWidgetAndSettle(const MyApp());
    // ... login steps ...
    
    // Restart app
    await $.native.pressHome();
    await $.native.openApp();
    
    // Verify still logged in
    expect($(#homeScreen), findsOneWidget);
  });
}
```

## Migration from FakeAuthRepository

To migrate from the fake implementation to the real API:

1. Update the auth repository provider:
```dart
// OLD
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

// NEW
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(
    apiClient: AuthApiClient(baseUrl: apiBaseUrl),
  );
});
```

2. Handle API errors in the UI:
```dart
try {
  await authNotifier.login(credentials);
} catch (e) {
  if (e is AuthException) {
    // Show user-friendly error message
    showErrorSnackBar(e.message);
  }
}
```

3. Update tests to use mock API responses instead of fake data

## Security Considerations

### Do's
✅ Store tokens securely using flutter_secure_storage
✅ Implement automatic token refresh
✅ Clear all data on logout
✅ Use HTTPS for all API calls
✅ Validate tokens before making API calls
✅ Handle token expiration gracefully

### Don'ts
❌ Store tokens in SharedPreferences (not secure)
❌ Store passwords in plain text
❌ Send tokens in URL parameters
❌ Keep tokens in memory longer than needed
❌ Reuse refresh tokens after they expire

## Troubleshooting

### Token Refresh Failing
- Check if refresh token has expired (7 days)
- Verify network connectivity
- Check API server status
- Ensure refresh token is saved correctly

### Social Login Not Working
- Verify OAuth client IDs are configured
- Check redirect URIs are set up correctly
- Ensure required scopes are requested
- Test with platform-specific debug tools

### Session Not Persisting
- Check secure storage permissions
- Verify user data is being saved after login
- Ensure token manager is started after login
- Check for errors in storage service

## Next Steps

1. ✅ Backend API implemented
2. ✅ Mobile API client created
3. ✅ Token refresh logic implemented
4. 🔲 Add social login SDK integration
5. 🔲 Update UI for social login buttons
6. 🔲 Implement Patrol tests
7. 🔲 Add comprehensive error handling
8. 🔲 Deploy to production
