# Emergency Feature - Rapid Crime SOS

## Overview

This feature module implements a **Rapid Crime SOS** system that allows users to quickly report violent crimes in progress with minimal friction. The feature is designed to be fast, discreet, and extensible.

## Architecture

The feature follows clean architecture principles with three main layers:

### Domain Layer (`domain/`)

**Purpose**: Core business logic and entities, independent of any framework or implementation details.

- **`emergency_type.dart`**: Enum defining types of emergencies
  - `violentCrime`
  - `sexualAssault`
  - `physicalAssault`
  - `kidnapping`
  - `otherViolentCrime`

- **`rapid_emergency_request.dart`**: Entity representing an emergency request
  - `id`: Unique identifier (UUID)
  - `type`: Emergency type (optional, can be set later)
  - `createdAt`: Timestamp
  - `location`: GPS coordinates (optional)
  - `isHighPriority`: Priority flag (default: true)

- **`emergency_repository.dart`**: Abstract repository interface
  - `sendRapidEmergency()`: Send emergency request
  - `getLastEmergency()`: Retrieve last emergency (for testing)

### Data Layer (`data/`)

**Purpose**: Implementation of data sources and repositories.

- **`fake_emergency_repository.dart`**: Stub implementation for MVP
  - Logs emergency to console
  - Stores in memory for debugging
  - Simulates network delay (300ms)
  - TODO: Replace with real backend implementation

- **`location_service.dart`**: Abstract location service interface
  - `getCurrentLocation()`: Get current GPS coordinates
  - `isLocationEnabled()`: Check location services status
  - `requestLocationPermission()`: Request location permission

- **`fake_location_service.dart`**: Stub location service
  - Returns fake Dhaka, Bangladesh coordinates
  - TODO: Replace with geolocator or similar package

- **Providers**:
  - `emergency_repository_provider.dart`: Riverpod provider for repository
  - `location_service_provider.dart`: Riverpod provider for location service

### Presentation Layer (`presentation/`)

**Purpose**: UI components and state management.

- **`rapid_crime_sos_notifier.dart`**: State management with Riverpod
  - `RapidCrimeSosState`: Holds current state
    - `lastRequest`: Last emergency request
    - `isLoading`: Loading indicator
    - `errorMessage`: Error state
    - `showTypeSelector`: Whether to show type selector
  - `RapidCrimeSosNotifier`: State notifier with methods:
    - `triggerRapidCrimeSos()`: Send emergency (fast, non-blocking)
    - `updateEmergencyType()`: Update emergency type (optional)
    - `dismissTypeSelector()`: Close type selector

- **`rapid_crime_sos_sheet.dart`**: Bottom sheet UI for selecting emergency type
  - Shows 4 emergency type options
  - Can be skipped/dismissed
  - Updates emergency request when type is selected

## User Flow

1. **Trigger**: User taps "Crime in Progress" button on home screen
2. **Send**: Emergency is immediately sent with location
3. **Confirm**: User sees confirmation snackbar
4. **Optional**: Bottom sheet appears for selecting emergency type
5. **Skip or Select**: User can skip or select specific type

## Integration Points

### Home Screen

Added to `lib/features/home/home_screen.dart`:
- Import emergency feature modules
- Add `_triggerRapidCrimeSos()` method
- Add "Crime in Progress" button using `AppButton`
- Show confirmation and type selector sheet

### Localization

Added to `lib/l10n/app_en.arb` and `app_bn.arb`:
- `crimeInProgress`: Button label
- `rapidCrimeTitle`: Type selector title
- `rapidCrimeSubtitle`: Type selector subtitle
- `sexualAssault`: Sexual assault option
- `physicalAssault`: Physical assault option
- `kidnapping`: Kidnapping option
- `otherViolentCrime`: Other crime option
- `skipThisStep`: Skip button
- `rapidSosSent`: Confirmation title
- `rapidSosDescription`: Confirmation message

## Dependencies

Added to `pubspec.yaml`:
- `uuid: ^4.5.1`: For generating unique request IDs

## Testing

Unit tests in `test/unit/features/emergency/`:
- `rapid_emergency_request_test.dart`: Tests for domain entities
- `fake_emergency_repository_test.dart`: Tests for repository

## Future Enhancements (TODOs)

### Backend Integration
- [ ] Replace `FakeEmergencyRepository` with real API client
- [ ] Implement retry logic and offline support
- [ ] Add request queuing for failed sends

### Location Services
- [ ] Replace `FakeLocationService` with real location service
- [ ] Add `geolocator` package
- [ ] Handle location permissions properly
- [ ] Support background location updates

### Evidence Capture
- [ ] Auto-start audio recording
- [ ] Support photo/video capture
- [ ] Secure storage of evidence

### Notifications
- [ ] Send SMS to trusted contacts
- [ ] Push notifications to nearby responders
- [ ] In-app alerts

### Emergency Services
- [ ] Integration with 999 (Bangladesh emergency)
- [ ] Direct police station notification
- [ ] Emergency contact auto-dial

### Security & Privacy
- [ ] End-to-end encryption
- [ ] Secure evidence storage
- [ ] Privacy controls
- [ ] Data retention policies

## Design Principles

1. **Fast First**: Emergency is sent immediately, details can be added later
2. **Non-Blocking**: Never block user with forms or dialogs
3. **Discreet**: No loud sounds or flashing UI
4. **Graceful Degradation**: Works even without location or network
5. **Extensible**: Clean abstractions for future features
6. **Testable**: Repository pattern and dependency injection

## Notes

- This is an MVP implementation focused on mobile app structure
- No real backend integration in this version
- Location service is stubbed out
- Emergency "sending" just logs to console
- The feature is ready to be wired to real services when backend is ready
