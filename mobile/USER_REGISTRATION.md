# User Registration Feature

## Overview

This document describes the implementation of user registration functionality for the Shongkot Emergency Response mobile application. The feature allows new users to create accounts using either email addresses or phone numbers.

## Features

### Core Functionality
- ✅ User registration with email address
- ✅ User registration with phone number (Bangladesh format)
- ✅ Form validation for email/phone format
- ✅ Password strength requirements (min 8 chars, uppercase, lowercase, number)
- ✅ Password confirmation validation
- ✅ Terms of service and privacy policy acceptance
- ✅ Error handling for duplicate accounts
- ✅ Success screen after registration
- ✅ Navigation to main app after successful registration

## Architecture

The authentication feature follows the established feature-based architecture:

```
lib/features/auth/
├── domain/
│   ├── user.dart                    # User model
│   ├── auth_models.dart             # RegisterRequest, RegisterResponse, AuthException
│   ├── auth_repository.dart         # Repository interface
│   └── auth_validators.dart         # Form validation logic
├── data/
│   ├── fake_auth_repository.dart    # Mock implementation for development
│   └── auth_repository_provider.dart # Riverpod provider
└── presentation/
    ├── register_screen.dart         # Registration form UI
    ├── registration_success_screen.dart # Success confirmation
    ├── register_notifier.dart       # State management
    └── auth_state_provider.dart     # Authentication state
```

## Domain Models

### User
```dart
class User {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String? name;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
}
```

### RegisterRequest
```dart
class RegisterRequest {
  final String emailOrPhone;
  final String password;
  final bool acceptedTerms;
}
```

### RegisterResponse
```dart
class RegisterResponse {
  final String userId;
  final String? email;
  final String? phoneNumber;
  final String message;
}
```

## Validation Rules

### Email/Phone Validation
- **Email**: Standard RFC 5322 format validation
- **Phone**: Bangladesh phone number formats:
  - `01XXXXXXXXX` (11 digits starting with 01)
  - `+8801XXXXXXXXX` (with country code)
  - `8801XXXXXXXXX` (without + symbol)
  - Valid prefixes: 013, 014, 015, 016, 017, 018, 019

### Password Requirements
- Minimum 8 characters
- At least one uppercase letter (A-Z)
- At least one lowercase letter (a-z)
- At least one number (0-9)

### Terms Acceptance
- User must explicitly check the terms acceptance checkbox
- Registration cannot proceed without accepting terms

## State Management

The feature uses Riverpod for state management:

### Providers
- `authRepositoryProvider`: Provides access to the auth repository
- `registerProvider`: Manages registration state and actions
- `currentUserProvider`: Tracks current authenticated user
- `isAuthenticatedProvider`: Boolean flag for authentication status

### Register State
```dart
class RegisterState {
  final bool isLoading;           // Loading indicator
  final RegisterResponse? response; // Success response
  final String? error;             // Error message
}
```

## User Flow

1. **App Launch**: 
   - `AuthGate` checks authentication status
   - Unauthenticated users see `RegisterScreen`
   - Authenticated users see main app navigation

2. **Registration**:
   - User enters email/phone, password, and confirms password
   - User accepts terms and privacy policy
   - Form validation runs on submit
   - If valid, registration request sent to repository
   - Loading state shown during processing

3. **Success**:
   - `RegistrationSuccessScreen` displayed
   - User can continue to app or verify account
   - Navigation to main app (`AppNavigation`)

4. **Error Handling**:
   - Duplicate account: "An account with this email/phone already exists"
   - Network errors: "Network error. Please check your connection."
   - Generic errors: "Registration failed. Please try again."

## Backend API

### Endpoint
```
POST /api/auth/register
```

### Request Body
```json
{
  "email": "user@example.com",
  "phoneNumber": null,
  "password": "Test1234",
  "acceptedTerms": true
}
```

### Response (201 Created)
```json
{
  "userId": "guid",
  "email": "user@example.com",
  "phoneNumber": null,
  "message": "Registration successful"
}
```

### Error Responses
- **400 Bad Request**: Invalid request data
- **409 Conflict**: Account already exists

## Testing

### Unit Tests
Location: `test/unit/features/auth/auth_validators_test.dart`

Tests cover:
- Email format validation (valid/invalid cases)
- Phone format validation (Bangladesh formats)
- Password strength validation (all requirements)
- Password confirmation matching
- Terms acceptance validation

**Coverage**: 50+ test cases

### Widget Tests
Location: `test/widget/features/auth/register_screen_test.dart`

Tests cover:
- All form fields render correctly
- Validation errors display properly
- Password visibility toggle works
- Terms checkbox functionality
- Form submission behavior

**Coverage**: 8 widget test scenarios

### Running Tests
```bash
cd mobile

# Run all tests
flutter test

# Run specific test file
flutter test test/unit/features/auth/auth_validators_test.dart

# Run with coverage
flutter test --coverage
```

## Localization

All UI strings are localized in English and Bengali:
- English: `lib/l10n/app_en.arb`
- Bengali: `lib/l10n/app_bn.arb`

**New strings added**: 29

### Key Localization Keys
- `register`, `registerTitle`, `registerSubtitle`
- `password`, `confirmPassword`
- `emailOrPhone`, `emailRequired`, `emailInvalid`
- `phoneRequired`, `phoneInvalid`
- `passwordRequired`, `passwordTooShort`, etc.
- `registrationSuccess`, `registrationSuccessMessage`
- `accountExists`, `registrationFailed`, `networkError`

## Future Enhancements

### Ready for Implementation
The architecture is designed to easily integrate:

1. **Firebase Authentication**
   - Replace `FakeAuthRepository` with `FirebaseAuthRepository`
   - Implement email/SMS verification
   - Add social login (Google, Facebook)

2. **Custom Backend API**
   - Replace fake repository with HTTP client
   - Implement JWT token management
   - Add refresh token logic

3. **Email/Phone Verification**
   - Send verification code via email/SMS
   - Verification screen implementation
   - Resend code functionality

4. **Password Recovery**
   - Forgot password flow
   - Reset password via email/SMS

5. **Login Screen**
   - Implement login with registered credentials
   - "Remember me" functionality
   - Biometric authentication

## Security Considerations

### Current Implementation
- Passwords handled securely in memory
- Form validation prevents common input errors
- Terms acceptance enforced

### Production Requirements
- ⚠️ Backend password hashing (use BCrypt or Argon2)
- ⚠️ HTTPS for all API communications
- ⚠️ Rate limiting on registration endpoint
- ⚠️ CAPTCHA to prevent automated registrations
- ⚠️ Email/phone verification before full access
- ⚠️ Secure token storage (Flutter Secure Storage)

## Dependencies

No new dependencies were added. The feature uses existing packages:
- `flutter_riverpod`: State management
- `firebase_core`: Firebase integration (already configured)

## Migration Notes

### Updating from Previous Version
The app now requires authentication. Users will:
1. See registration screen on first launch
2. Need to register to access features
3. Stay logged in until explicitly logged out

### Data Migration
No existing user data requires migration. This is a new feature.

## Troubleshooting

### Common Issues

**Issue**: Registration button does nothing
- **Solution**: Check form validation errors, ensure terms are accepted

**Issue**: "Account already exists" error
- **Solution**: Try logging in or use password recovery (when implemented)

**Issue**: Phone number validation fails
- **Solution**: Ensure phone number follows Bangladesh format (01XXXXXXXXX)

**Issue**: Tests failing
- **Solution**: Run `flutter pub get` to ensure dependencies are installed

## Code Examples

### Using Auth Repository
```dart
final authRepository = ref.read(authRepositoryProvider);

final request = RegisterRequest(
  emailOrPhone: 'user@example.com',
  password: 'Test1234',
  acceptedTerms: true,
);

try {
  final response = await authRepository.register(request);
  print('Registered: ${response.userId}');
} on AuthException catch (e) {
  print('Error: ${e.message}');
}
```

### Checking Authentication Status
```dart
final user = await ref.read(currentUserProvider.future);
if (user != null) {
  print('Logged in as: ${user.email ?? user.phoneNumber}');
} else {
  print('Not logged in');
}
```

## Contributing

When extending this feature:
1. Follow the established architecture patterns
2. Add tests for new functionality
3. Update localization strings in both languages
4. Document changes in this file
5. Ensure backward compatibility

## References

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Form Validation](https://docs.flutter.dev/cookbook/forms/validation)
- [Material Design - Sign Up](https://material.io/design/communication/sign-up.html)
