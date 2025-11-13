# Shongkot Mobile App

Emergency responder mobile application built with Flutter.

## Features

- 🚨 **Emergency SOS Button** - One-tap emergency activation with hold-to-confirm
- 📱 **Modern UI** - Clean, minimal design inspired by shadcn
- 🌓 **Dark/Light Theme** - Full theme support with system preference detection
- 🌍 **Multi-language** - Support for English and Bengali
- 👥 **Emergency Contacts** - Manage and contact emergency contacts
- 🗺️ **Nearby Responders** - Find and contact nearby emergency responders
- ⚙️ **Settings** - Customize theme, language, and preferences

## Design System

The app uses a comprehensive design system for consistency and maintainability:

- **[Design System Documentation](DESIGN_SYSTEM.md)** - Complete design system overview
- **[Component Usage Guide](COMPONENT_GUIDE.md)** - Examples and best practices

### Key Features

- Shadcn-inspired minimal design
- Consistent color system with semantic colors
- Typography scale using Inter font
- Reusable component library
- Theme persistence
- Localization support

## Getting Started

### Prerequisites

- Flutter SDK 3.35.3 or later
- Dart SDK 3.9.0 or later
- Android Studio / Xcode for platform-specific builds

### Installation

```bash
# Get dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run the app
flutter run
```

### Development

```bash
# Run in debug mode
flutter run --debug

# Run with hot reload enabled
flutter run --hot

# Run on specific device
flutter run -d <device_id>
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format lib/ test/

# Check for outdated packages
flutter pub outdated
```

### Building

```bash
# Build APK for Android
flutter build apk --release

# Build App Bundle for Google Play
flutter build appbundle --release

# Build for iOS (macOS only)
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── core/
│   ├── constants/                 # Design system constants
│   │   ├── app_colors.dart       # Color palette
│   │   ├── app_spacing.dart      # Spacing scale
│   │   └── app_typography.dart   # Typography system
│   ├── theme/
│   │   └── app_theme.dart        # Theme configurations
│   ├── providers/                 # State management
│   │   ├── theme_provider.dart   # Theme state
│   │   └── locale_provider.dart  # Language state
│   └── navigation/
│       └── app_navigation.dart   # Navigation structure
├── shared/
│   └── widgets/                   # Reusable components
│       ├── app_button.dart
│       ├── app_card.dart
│       └── app_text_field.dart
├── features/                      # Feature modules
│   ├── home/                     # Home screen
│   ├── contacts/                 # Contacts management
│   ├── responders/               # Responders finder
│   └── settings/                 # Settings screen
└── l10n/                         # Localization
    ├── app_en.arb               # English
    └── app_bn.arb               # Bengali

test/
├── unit/                         # Unit tests
├── widget/                       # Widget tests
└── widget_test.dart             # Main widget test

assets/
├── images/                       # Image assets
└── icons/                        # Icon assets
```

## State Management

The app uses **Riverpod** for state management:

- Theme state (light/dark/system)
- Locale state (language preference)
- Navigation state
- Feature-specific state

## Internationalization

### Supported Languages

- **English** (en) - Default
- **Bengali** (বাংলা) - bn

### Adding Translations

1. Add keys to `lib/l10n/app_en.arb`
2. Add translations to `lib/l10n/app_bn.arb`
3. Run `flutter gen-l10n`
4. Use in code: `AppLocalizations.of(context)!.key`

## Theming

The app supports three theme modes:

- **Light** - Clean white background
- **Dark** - Deep zinc background for reduced eye strain
- **System** - Follows device theme preference

Theme preference is persisted using SharedPreferences.

## CI/CD

The app is automatically built and deployed via GitHub Actions:

- **Analyze & Test** - Code quality checks and tests
- **Build APK/AAB** - Android builds
- **Deploy to Firebase** - Firebase App Distribution
- **GitHub Releases** - Release artifacts

See [.github/workflows/frontend-cicd.yml](../.github/workflows/frontend-cicd.yml) for details.

## Firebase Integration

- **Firebase Core** - App initialization
- **Firebase App Check** - Security
- **Firebase App Distribution** - Beta distribution

Note: `firebase_options.dart` is generated during CI/CD. For local development, a stub file is used.

## Contributing

1. Follow the design system guidelines
2. Write tests for new features
3. Use localization for all user-facing text
4. Support both light and dark themes
5. Run `flutter analyze` before committing
6. Format code with `dart format`

## Documentation

- [Design System](DESIGN_SYSTEM.md) - Complete design system
- [Component Guide](COMPONENT_GUIDE.md) - Component usage examples
- [Main README](../README.md) - Project overview
- [Architecture](../docs/ARCHITECTURE.md) - System architecture

## License

This project is proprietary software. See [LICENSE](../LICENSE) for details.

**Copyright © 2025 Omar Khaium. All Rights Reserved.**
