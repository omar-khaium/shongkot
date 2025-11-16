# Authentication System Deployment Guide

## Overview
This guide provides step-by-step instructions for deploying the OAuth2 authentication system to production.

## Prerequisites

### Backend
- Google Cloud Platform account
- Cloud Run enabled
- Docker installed (for local testing)
- .NET 9.0 SDK

### Mobile
- Flutter 3.35.3+
- Android Studio / Xcode
- Firebase project (for social login)
- Google, Facebook, and Apple developer accounts (for social login)

## Backend Deployment

### 1. Configure Secrets

Before deploying, set up secure JWT secret key:

```bash
# Generate a secure 32+ character secret key
openssl rand -base64 32

# Set as environment variable in Cloud Run
JWT_SECRET_KEY="your-generated-secret-key"
```

### 2. Update Configuration

Update `appsettings.Production.json`:
```json
{
  "Jwt": {
    "SecretKey": "${JWT_SECRET_KEY}",
    "Issuer": "Shongkot",
    "Audience": "ShongkotApp",
    "AccessTokenExpirationMinutes": "15",
    "RefreshTokenExpirationDays": "7"
  }
}
```

### 3. Deploy to Cloud Run

#### Option A: Using gcloud CLI

```bash
cd backend

# Build and deploy
gcloud builds submit --tag gcr.io/PROJECT_ID/shongkot-api
gcloud run deploy shongkot-api \
  --image gcr.io/PROJECT_ID/shongkot-api \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars JWT_SECRET_KEY="your-secret-key"
```

#### Option B: Using GitHub Actions

The existing CI/CD workflow will deploy automatically when changes are pushed to main/backend branch.

Update secrets in GitHub:
- `GCP_PROJECT_ID`
- `GCP_SA_KEY`
- `JWT_SECRET_KEY`

### 4. Configure CORS (if needed)

If your mobile app domain is different, update CORS in `Program.cs`:

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowMobile",
        builder => builder
            .WithOrigins("https://yourdomain.com")
            .AllowAnyMethod()
            .AllowAnyHeader());
});
```

### 5. Verify Deployment

Test all endpoints:

```bash
API_URL="https://your-api-url.run.app"

# Health check
curl $API_URL/health

# Register
curl -X POST $API_URL/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123456","acceptedTerms":true}'

# Login
curl -X POST $API_URL/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"emailOrPhone":"test@example.com","password":"Test123456"}'
```

## Social Login Setup

### Google Sign-In

#### 1. Create OAuth Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Enable Google+ API
3. Create OAuth 2.0 Client IDs:
   - **Android**: Use your app's SHA-1 fingerprint
   - **iOS**: Use your iOS bundle ID

#### 2. Configure Mobile App

```yaml
# pubspec.yaml
dependencies:
  google_sign_in: ^6.1.5
```

Android configuration (`android/app/build.gradle`):
```gradle
defaultConfig {
    ...
    manifestPlaceholders = [
        'appAuthRedirectScheme': 'com.example.shongkot'
    ]
}
```

iOS configuration (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

#### 3. Implementation

```dart
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
  scopes: ['email', 'profile'],
);

Future<void> signInWithGoogle() async {
  try {
    final account = await _googleSignIn.signIn();
    if (account == null) return;
    
    final auth = await account.authentication;
    final idToken = auth.idToken;
    
    // Send to backend
    final user = await authRepository.loginWithGoogle(idToken!);
  } catch (error) {
    print('Google Sign-In Error: $error');
  }
}
```

### Facebook Login

#### 1. Create Facebook App

1. Go to [Facebook Developers](https://developers.facebook.com)
2. Create a new app
3. Add Facebook Login product
4. Configure OAuth redirect URIs

#### 2. Configure Mobile App

```yaml
# pubspec.yaml
dependencies:
  flutter_facebook_auth: ^6.0.3
```

Android configuration (`android/app/src/main/res/values/strings.xml`):
```xml
<string name="facebook_app_id">YOUR_APP_ID</string>
<string name="fb_login_protocol_scheme">fbYOUR_APP_ID</string>
<string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>
```

Android manifest:
```xml
<meta-data
    android:name="com.facebook.sdk.ApplicationId"
    android:value="@string/facebook_app_id"/>
```

iOS configuration (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbYOUR_APP_ID</string>
    </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>YOUR_APP_ID</string>
<key>FacebookClientToken</key>
<string>YOUR_CLIENT_TOKEN</string>
<key>FacebookDisplayName</key>
<string>Shongkot</string>
```

#### 3. Implementation

```dart
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> signInWithFacebook() async {
  final result = await FacebookAuth.instance.login();
  
  if (result.status == LoginStatus.success) {
    final accessToken = result.accessToken!.token;
    
    // Send to backend
    final user = await authRepository.loginWithFacebook(accessToken);
  }
}
```

### Apple Sign In (iOS only)

#### 1. Enable Apple Sign In

1. Go to Apple Developer Portal
2. Enable Sign in with Apple for your App ID
3. Create a Service ID for web authentication

#### 2. Configure Mobile App

```yaml
# pubspec.yaml
dependencies:
  sign_in_with_apple: ^5.0.0
```

iOS configuration:
1. Enable "Sign in with Apple" capability in Xcode
2. Add to `Info.plist` if needed

#### 3. Implementation

```dart
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<void> signInWithApple() async {
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );
  
  // Send to backend
  final user = await authRepository.loginWithApple(credential.identityToken!);
}
```

## Mobile Deployment

### 1. Update API Configuration

Create environment configuration:

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://your-api-url.run.app',
  );
}
```

### 2. Switch to Real Auth Repository

Update `auth_repository_provider.dart`:

```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(
    apiClient: AuthApiClient(
      baseUrl: ApiConfig.baseUrl,
    ),
  );
});
```

### 3. Add Social Login Buttons

Update `LoginScreen`:

```dart
// After password login button
if (Platform.isAndroid || Platform.isIOS) ...[
  const SizedBox(height: AppSpacing.md),
  const Text('Or continue with', textAlign: TextAlign.center),
  const SizedBox(height: AppSpacing.md),
  
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SocialLoginButton(
        icon: Icons.g_mobiledata,
        onPressed: () => authNotifier.loginWithGoogle(),
        label: 'Google',
      ),
      const SizedBox(width: AppSpacing.sm),
      SocialLoginButton(
        icon: Icons.facebook,
        onPressed: () => authNotifier.loginWithFacebook(),
        label: 'Facebook',
      ),
      if (Platform.isIOS) ...[
        const SizedBox(width: AppSpacing.sm),
        SocialLoginButton(
          icon: Icons.apple,
          onPressed: () => authNotifier.loginWithApple(),
          label: 'Apple',
        ),
      ],
    ],
  ),
],
```

### 4. Build and Deploy

#### Android

```bash
cd mobile

# Build release APK
flutter build apk --release

# Or build App Bundle for Play Store
flutter build appbundle --release
```

#### iOS

```bash
cd mobile

# Build iOS release
flutter build ios --release

# Archive in Xcode for App Store
open ios/Runner.xcworkspace
```

## Testing

### End-to-End Testing

1. **Register a new account**
   - Test with email
   - Test with phone number

2. **Login with password**
   - Verify token is received
   - Check session persistence

3. **Token refresh**
   - Wait 13+ minutes (access token expires in 15)
   - Make an API call
   - Verify token is auto-refreshed

4. **Social login**
   - Test Google Sign-In
   - Test Facebook Login
   - Test Apple Sign In (iOS)

5. **Password change**
   - Change password
   - Verify old session is invalidated
   - Login with new password

6. **Logout**
   - Logout
   - Verify tokens are cleared
   - Verify cannot access protected resources

### Patrol Integration Tests

Install Patrol:
```yaml
dev_dependencies:
  patrol: ^3.0.0
```

Run integration tests:
```bash
patrol test
```

## Monitoring

### Backend

Monitor in Google Cloud Console:
- Request count
- Error rate
- Response times
- Authentication failures

Set up alerts for:
- High error rates
- Slow response times
- Failed authentication attempts

### Mobile

Use Firebase Analytics to track:
- Login success/failure rates
- Social login usage
- Token refresh frequency
- Session duration

## Security Checklist

### Backend
- [ ] Secure JWT secret key (32+ characters)
- [ ] HTTPS only (Cloud Run provides this)
- [ ] Rate limiting on auth endpoints
- [ ] Password complexity requirements
- [ ] Account lockout after failed attempts
- [ ] SQL injection prevention (when database added)
- [ ] XSS prevention
- [ ] CSRF tokens for web

### Mobile
- [ ] Secure storage for tokens
- [ ] Certificate pinning (recommended)
- [ ] Obfuscate code in release builds
- [ ] No sensitive data in logs
- [ ] Validate server certificates
- [ ] Handle biometric authentication securely

## Troubleshooting

### Common Issues

**Token refresh failing**
- Check if JWT_SECRET_KEY matches between environments
- Verify refresh token hasn't expired
- Check system time is synchronized

**Social login not working**
- Verify OAuth client IDs are correct
- Check redirect URIs are configured
- Ensure required permissions are granted

**CORS errors**
- Update CORS policy in backend
- Verify origin is allowed
- Check request headers

**Session not persisting**
- Check secure storage permissions
- Verify tokens are being saved
- Test on real device, not emulator

## Rollback Plan

If issues occur in production:

1. Revert to previous Cloud Run revision:
```bash
gcloud run services update-traffic shongkot-api \
  --to-revisions PREVIOUS_REVISION=100
```

2. Revert mobile app:
- Roll back to previous version in stores
- Use remote config to disable new features

## Support

For issues or questions:
- Create an issue on GitHub
- Check logs in Cloud Run console
- Review API documentation at `/swagger`

## Next Steps

After deployment:
1. Monitor for first 24 hours
2. Gather user feedback
3. Optimize based on metrics
4. Plan for database migration (currently using in-memory storage)
5. Add additional security features (2FA, device management)
