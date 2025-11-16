# SMS/Email Verification Implementation Guide

## Overview
This guide explains how the SMS/Email verification feature was implemented in the Shongkot Emergency Responder application, including both backend (ASP.NET Core) and mobile (Flutter) components.

## Architecture

### Backend (ASP.NET Core)

```
┌─────────────────────────────────────────────────────────┐
│                    Shongkot.Api                          │
│  ┌───────────────────────────────────────────────────┐  │
│  │           AuthController                          │  │
│  │  - POST /api/auth/send-code                       │  │
│  │  - POST /api/auth/verify                          │  │
│  │  - POST /api/auth/resend-code                     │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│               Shongkot.Application                       │
│  ┌───────────────────────────────────────────────────┐  │
│  │       IVerificationService (Interface)            │  │
│  │  - GenerateCodeAsync()                            │  │
│  │  - VerifyCodeAsync()                              │  │
│  │  - CanResendCodeAsync()                           │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│              Shongkot.Infrastructure                     │
│  ┌───────────────────────────────────────────────────┐  │
│  │      MockVerificationService                      │  │
│  │  - In-memory code storage                         │  │
│  │  - Rate limiting (60s cooldown)                   │  │
│  │  - Code expiration (5 minutes)                    │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Mobile (Flutter)

```
┌─────────────────────────────────────────────────────────┐
│                  Presentation Layer                      │
│  ┌───────────────────────────────────────────────────┐  │
│  │         VerificationScreen (UI)                   │  │
│  │  - 6-digit OTP input                              │  │
│  │  - Verify button                                  │  │
│  │  - Resend button with countdown                   │  │
│  └───────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────┐  │
│  │    VerificationNotifier (State Management)        │  │
│  │  - Riverpod StateNotifier                         │  │
│  │  - Handles verification logic                     │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                     Data Layer                           │
│  ┌───────────────────────────────────────────────────┐  │
│  │       VerificationApiService                      │  │
│  │  - HTTP client wrapper                            │  │
│  │  - API endpoint calls                             │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    Domain Layer                          │
│  ┌───────────────────────────────────────────────────┐  │
│  │  VerificationRequest / VerificationResponse       │  │
│  │  - Data models                                    │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Implementation Details

### Backend Components

#### 1. Domain Entities

**User.cs**
```csharp
public class User
{
    public Guid Id { get; set; }
    public string? PhoneNumber { get; set; }
    public string? Email { get; set; }
    public bool IsPhoneVerified { get; set; }
    public bool IsEmailVerified { get; set; }
    // ... other properties
}
```

**VerificationCode.cs**
```csharp
public class VerificationCode
{
    public Guid Id { get; set; }
    public string Identifier { get; set; }  // Email or Phone
    public VerificationType Type { get; set; }
    public string Code { get; set; }
    public DateTime ExpiresAt { get; set; }
    public bool IsUsed { get; set; }
    // ... other properties
}
```

#### 2. Service Layer

**IVerificationService.cs** - Interface defining verification operations
- `GenerateCodeAsync()` - Creates and sends verification code
- `VerifyCodeAsync()` - Validates a verification code
- `CanResendCodeAsync()` - Checks rate limiting

**MockVerificationService.cs** - Implementation for development/testing
- In-memory storage using static dictionaries
- 60-second rate limiting
- 5-minute code expiration
- Console logging for testing

#### 3. API Controller

**AuthController.cs**
- `POST /api/auth/send-code` - Sends initial verification code
- `POST /api/auth/verify` - Verifies the code
- `POST /api/auth/resend-code` - Resends verification code

### Mobile Components

#### 1. Domain Models

**VerificationRequest** - Request data for sending codes
**VerificationResponse** - Response data from API

#### 2. Data Layer

**VerificationApiService** - HTTP client for API calls
- Handles network errors gracefully
- Returns user-friendly error messages
- Configurable base URL

#### 3. State Management

**VerificationNotifier** - Riverpod StateNotifier
- Manages verification state
- Handles loading, error, and success states
- Implements client-side rate limiting
- Tracks code expiration

**VerificationState** - Immutable state class
- `isLoading` - Loading indicator
- `error` - Error message
- `isVerified` - Verification status
- `expiresAt` - Code expiration time
- `lastResendTime` - For rate limiting
- Computed properties: `canResend`, `secondsUntilCanResend`

#### 4. Presentation

**VerificationScreen** - Flutter widget
- 6 separate TextField widgets for OTP digits
- Auto-focus next field on input
- Digit-only input validation
- Auto-submit when all 6 digits entered
- Resend button with countdown
- Error handling via SnackBar

## Features Implemented

### ✅ Core Features
- [x] Send verification code via email/phone
- [x] 6-digit OTP input screen
- [x] Code verification
- [x] Resend code functionality
- [x] Rate limiting (60 seconds between resends)
- [x] Code expiration (5 minutes)
- [x] Invalid/expired code error handling

### ✅ User Experience
- [x] Loading indicators
- [x] Error messages
- [x] Success confirmation
- [x] Auto-focus on OTP inputs
- [x] Digit-only input filtering
- [x] Countdown timer for resend
- [x] Expiration time display

### ✅ Testing
- [x] Backend unit tests (10 tests)
- [x] Mobile unit tests (verification notifier)
- [x] Mobile widget tests (verification screen)
- [x] All tests passing

### ✅ Localization
- [x] English translations
- [x] Bengali translations

## Usage Example

### Navigating to Verification Screen

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => VerificationScreen(
      identifier: 'user@example.com',
      type: VerificationType.email,
      onVerificationSuccess: () {
        // Navigate to next screen or show success message
        Navigator.pushReplacementNamed(context, '/home');
      },
    ),
  ),
);
```

### Using Verification Notifier Directly

```dart
// In your widget
final verificationState = ref.watch(verificationProvider);
final verificationNotifier = ref.read(verificationProvider.notifier);

// Send code
await verificationNotifier.sendCode(
  VerificationRequest(
    identifier: 'user@example.com',
    type: VerificationType.email,
  ),
);

// Verify code
final isValid = await verificationNotifier.verifyCode('123456');
if (isValid) {
  // Code is valid, proceed
}
```

## Testing

### Backend Tests
```bash
cd backend
dotnet test
```

All 10 tests pass:
- 5 tests for AuthController
- 5 tests for EmergencyController

### Mobile Tests
```bash
cd mobile
flutter test
```

Tests cover:
- Verification notifier state management
- OTP input screen widgets
- Rate limiting logic
- Code expiration

## Configuration

### Backend Configuration

In `Program.cs`:
```csharp
builder.Services.AddScoped<IVerificationService, MockVerificationService>();
```

For production, replace with actual SMS/Email service:
```csharp
builder.Services.AddScoped<IVerificationService, TwilioVerificationService>();
// or
builder.Services.AddScoped<IVerificationService, SendGridVerificationService>();
```

### Mobile Configuration

In `verification_api_service.dart`, update the base URL:
```dart
static const String baseUrl = 'https://your-api-url.com/api';
```

## Security Considerations

1. **Rate Limiting**: 60-second cooldown prevents abuse
2. **Code Expiration**: 5-minute expiration limits exposure
3. **Single Use**: Codes can only be used once
4. **HTTPS**: Always use HTTPS in production
5. **Input Validation**: Digit-only validation on client and server

## Future Enhancements

### High Priority
1. Integrate real SMS gateway (Twilio, AWS SNS)
2. Integrate email service (SendGrid, AWS SES)
3. Database persistence for verification codes
4. IP-based rate limiting

### Medium Priority
1. Biometric verification option
2. Multi-factor authentication
3. Suspicious activity detection
4. Audit logging

### Low Priority
1. Custom code length
2. Voice call verification option
3. QR code verification

## Troubleshooting

### Code Not Received
- Check console logs for mock code
- Verify identifier is correct
- Check rate limiting hasn't been triggered

### Verification Fails
- Ensure code hasn't expired (5 minutes)
- Verify code is entered correctly
- Check backend logs for errors

### Network Errors
- Verify backend is running
- Check API base URL configuration
- Ensure CORS is configured correctly

## Related Documentation
- [VERIFICATION_API.md](./VERIFICATION_API.md) - API endpoint documentation
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Overall system architecture
- [SETUP.md](./SETUP.md) - Development setup guide

## Support
For questions or issues, please contact the development team or create an issue in the repository.
