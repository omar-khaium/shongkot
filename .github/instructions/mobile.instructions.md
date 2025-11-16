---
applies_to: mobile/
---

# Mobile Instructions (Flutter/Dart)

## Architecture

Follow Clean Architecture with BLoC pattern for state management:

### Layers Structure
```
lib/features/{feature}/
├── presentation/   # UI, BLoC, widgets
├── domain/        # Entities, use cases, repository interfaces
└── data/          # Models, repository implementations, data sources
```

### Core Structure
```
lib/core/
├── config/        # App configuration
├── constants/     # Constants and enums
├── error/         # Error handling
├── network/       # API client setup
├── theme/         # App theming
└── utils/         # Utility functions
```

## Coding Standards

### Naming Conventions
- **Classes/Types**: UpperCamelCase (`EmergencyButton`)
- **Variables/Functions**: lowerCamelCase (`onEmergencyPressed`)
- **Private members**: prefix with `_` (`_isLoading`)
- **Constants**: lowerCamelCase or SCREAMING_SNAKE_CASE

### Widget Structure
```dart
class EmergencyButton extends StatelessWidget {
  const EmergencyButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
  });

  final VoidCallback onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      child: const Text('Emergency'),
    );
  }
}
```

### BLoC Pattern
```dart
// Event
sealed class EmergencyEvent {}
class TriggerEmergency extends EmergencyEvent {
  final Location location;
  TriggerEmergency(this.location);
}

// State
sealed class EmergencyState {}
class EmergencyInitial extends EmergencyState {}
class EmergencyLoading extends EmergencyState {}
class EmergencyTriggered extends EmergencyState {
  final Emergency emergency;
  EmergencyTriggered(this.emergency);
}
class EmergencyError extends EmergencyState {
  final String message;
  EmergencyError(this.message);
}

// BLoC
class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final TriggerEmergencyUseCase _triggerEmergency;
  
  EmergencyBloc(this._triggerEmergency) : super(EmergencyInitial()) {
    on<TriggerEmergency>(_onTriggerEmergency);
  }
  
  Future<void> _onTriggerEmergency(
    TriggerEmergency event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(EmergencyLoading());
    try {
      final result = await _triggerEmergency(event.location);
      emit(EmergencyTriggered(result));
    } catch (e) {
      emit(EmergencyError(e.toString()));
    }
  }
}
```

## Testing Requirements

### Test Structure
```
test/
├── features/
│   └── {feature}/
│       ├── presentation/   # Widget & BLoC tests
│       ├── domain/        # Use case tests
│       └── data/          # Repository tests
├── core/              # Core utilities tests
└── helpers/           # Test helpers and mocks
```

### Test Naming
```dart
void main() {
  group('EmergencyBloc', () {
    test('emits EmergencyTriggered when TriggerEmergency succeeds', () async {
      // Arrange
      // Act
      // Assert
    });
    
    test('emits EmergencyError when TriggerEmergency fails', () async {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### Widget Tests
```dart
testWidgets('EmergencyButton calls onPressed when tapped', (tester) async {
  var pressed = false;
  
  await tester.pumpWidget(
    MaterialApp(
      home: EmergencyButton(onPressed: () => pressed = true),
    ),
  );
  
  await tester.tap(find.byType(EmergencyButton));
  expect(pressed, isTrue);
});
```

### Coverage Requirements
- Unit tests: 75% minimum
- Test all business logic (BLoCs, use cases, repositories)
- Widget tests for complex UI components
- Test edge cases and error states

## Dependencies

### Adding Packages
```bash
flutter pub add package_name
flutter pub add --dev package_name  # For dev dependencies
```

### Common Packages
- **State Management**: flutter_bloc
- **Navigation**: go_router
- **HTTP**: dio
- **Local Storage**: hive, shared_preferences
- **Maps**: google_maps_flutter
- **Firebase**: firebase_core, firebase_messaging, firebase_analytics
- **Testing**: flutter_test, mockito, bloc_test

## Build & Test Commands

```bash
# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Format code
dart format .

# Check formatting
dart format --output=none --set-exit-if-changed .

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test
flutter test test/features/emergency/emergency_bloc_test.dart

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Run app
flutter run
flutter run -d android  # Specific device
```

## Code Organization

### Feature Structure Example
```
lib/features/emergency/
├── presentation/
│   ├── bloc/
│   │   ├── emergency_bloc.dart
│   │   ├── emergency_event.dart
│   │   └── emergency_state.dart
│   ├── pages/
│   │   └── emergency_page.dart
│   └── widgets/
│       ├── emergency_button.dart
│       └── emergency_status.dart
├── domain/
│   ├── entities/
│   │   └── emergency.dart
│   ├── repositories/
│   │   └── emergency_repository.dart
│   └── usecases/
│       └── trigger_emergency.dart
└── data/
    ├── models/
    │   └── emergency_model.dart
    ├── repositories/
    │   └── emergency_repository_impl.dart
    └── datasources/
        └── emergency_remote_datasource.dart
```

## Best Practices

### Const Constructors
```dart
// Good
const Text('Hello')
const SizedBox(height: 16)
const Icon(Icons.emergency)

// Prefer const when possible
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
}
```

### Null Safety
- Use null-aware operators (`?.`, `??`, `??=`)
- Prefer non-nullable types
- Use `late` sparingly and only when necessary

### Async/Await
```dart
Future<void> loadData() async {
  try {
    final data = await repository.fetchData();
    // Handle data
  } catch (e) {
    // Handle error
  }
}
```

### Error Handling
- Use try-catch for async operations
- Return Result/Either types for cleaner error handling
- Show user-friendly error messages

## Firebase Configuration

- Never commit `google-services.json` or `GoogleService-Info.plist`
- Use example files as templates
- Store Firebase config in secrets for CI/CD
- Use FlutterFire CLI for configuration

## Before Committing

1. Run `flutter analyze` - ensure no analysis errors
2. Run `dart format .` - format all code
3. Run `flutter test` - ensure all tests pass
4. Check code coverage meets 75% minimum
5. Test on physical device if UI changes
6. Ensure no TODO comments remain
7. Update relevant documentation
