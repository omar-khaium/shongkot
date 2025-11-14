# Shongkot Mobile App - Design System

## Overview

The Shongkot mobile app uses a minimal, consistent design system inspired by shadcn/ui. The design system emphasizes:

- **Consistency**: Uniform components and patterns throughout the app
- **Accessibility**: Clear hierarchy and readable typography
- **Minimal Design**: Clean, focused interface without clutter
- **Theming**: Full support for light and dark modes
- **Internationalization**: Support for multiple languages (English and Bengali)

## Architecture

### Design System Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       # Color system
│   │   ├── app_spacing.dart      # Spacing scale
│   │   └── app_typography.dart   # Typography system
│   ├── theme/
│   │   └── app_theme.dart        # Theme configurations
│   ├── providers/
│   │   ├── theme_provider.dart   # Theme state management
│   │   └── locale_provider.dart  # Language state management
│   └── navigation/
│       └── app_navigation.dart   # App navigation structure
├── shared/
│   └── widgets/
│       ├── app_button.dart       # Reusable button component
│       ├── app_card.dart         # Reusable card component
│       └── app_text_field.dart   # Reusable text field component
├── features/
│   ├── home/                     # Home screen with SOS button
│   ├── contacts/                 # Emergency contacts management
│   ├── responders/               # Nearby responders
│   └── settings/                 # Settings and preferences
└── l10n/                         # Localization files
    ├── app_en.arb               # English translations
    └── app_bn.arb               # Bengali translations
```

## Color System

### Brand Colors

```dart
primary: #DC2626 (Red-600)
primaryLight: #EF4444 (Red-500)
primaryDark: #B91C1C (Red-700)
```

### Semantic Colors

```dart
success: #10B981 (Green-500)
warning: #F59E0B (Amber-500)
error: #EF4444 (Red-500)
info: #3B82F6 (Blue-500)
```

### Light Theme

```dart
background: #FFFFFF
surface: #FAFAFA
surfaceVariant: #F5F5F5
border: #E5E5E5
text: #18181B (Zinc-900)
textSecondary: #71717A (Zinc-500)
textMuted: #A1A1AA (Zinc-400)
```

### Dark Theme

```dart
background: #09090B (Zinc-950)
surface: #18181B (Zinc-900)
surfaceVariant: #27272A (Zinc-800)
border: #3F3F46 (Zinc-700)
text: #FAFAFA (Zinc-50)
textSecondary: #A1A1AA (Zinc-400)
textMuted: #71717A (Zinc-500)
```

## Typography

The app uses **Inter** font family from Google Fonts for a clean, modern look.

### Type Scale

```dart
Display: 32px, Bold
H1: 28px, Bold
H2: 24px, Semibold
H3: 20px, Semibold
H4: 18px, Semibold
Body Large: 16px, Regular
Body Medium: 14px, Regular
Body Small: 12px, Regular
Label: 14px, Medium
Label Small: 12px, Medium
Caption: 12px, Regular
Button: 14px, Semibold
```

## Spacing System

The app uses a 4px base unit for consistent spacing:

```dart
xs: 4px
sm: 8px
md: 16px
lg: 24px
xl: 32px
xxl: 48px
xxxl: 64px
```

### Border Radius

```dart
radiusSm: 4px
radiusMd: 8px
radiusLg: 12px
radiusXl: 16px
radiusFull: 999px (fully rounded)
```

## Components

### AppButton

Reusable button component with three variants:

```dart
AppButton(
  text: 'Button Text',
  onPressed: () {},
  variant: ButtonVariant.primary, // primary, secondary, ghost
  size: ButtonSize.medium, // small, medium, large
  icon: Icons.check, // optional
  isLoading: false, // optional
  fullWidth: false, // optional
)
```

### AppCard

Consistent card component:

```dart
AppCard(
  child: Text('Card content'),
  onTap: () {}, // optional
  padding: EdgeInsets.all(16), // optional
)
```

### AppTextField

Reusable text field:

```dart
AppTextField(
  label: 'Label',
  hint: 'Placeholder',
  controller: controller,
  validator: (value) => null,
  keyboardType: TextInputType.text,
)
```

## Theme Management

### Switching Themes

Users can switch between light, dark, and system themes:

```dart
// In the app
ref.read(themeProvider.notifier).setTheme(AppThemeMode.dark);
```

Theme preference is persisted using SharedPreferences and automatically applied on app launch.

## Internationalization

### Supported Languages

- **English (en)**: Default language
- **Bengali (bn)**: বাংলা

### Using Translations

```dart
// In widgets
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle);
```

### Switching Languages

```dart
ref.read(localeProvider.notifier).setLocale(Locale('bn'));
```

### Adding New Translations

1. Add new keys to `lib/l10n/app_en.arb`
2. Add translations to `lib/l10n/app_bn.arb`
3. Run `flutter gen-l10n` to generate localization classes

## Screens

### Home Screen

- **Emergency SOS Button**: Large, interactive button with press-and-hold animation
- **Location Status**: Quick status indicators for location services
- **Responders Count**: Shows number of nearby responders

### Contacts Screen

- **Contact List**: List of emergency contacts with call actions
- **Add Contact**: Button to add new emergency contacts
- **Primary Contact**: Visual indicator for primary emergency contact

### Responders Screen

- **Responder Cards**: Shows nearby responders with distance and ratings
- **Filter Options**: Filter responders by type (Medical, Fire, Police)
- **Contact Actions**: Quick call-to-action buttons

### Settings Screen

- **Theme Toggle**: Switch between light, dark, and system themes
- **Language Selector**: Choose between supported languages
- **Profile Section**: User information and edit options
- **About Section**: App version and legal information

## Navigation

The app uses a bottom navigation bar with four main sections:

1. **Home**: Emergency SOS and quick actions
2. **Contacts**: Manage emergency contacts
3. **Responders**: Find nearby responders
4. **Settings**: App preferences and profile

Navigation state is managed using Riverpod for consistent behavior.

## Best Practices

### Using Design System Components

1. **Always use design system colors**: Import from `app_colors.dart`
2. **Use spacing constants**: Import from `app_spacing.dart`
3. **Use typography helpers**: Import from `app_typography.dart`
4. **Prefer shared components**: Use AppButton, AppCard, etc.

### Adding New Components

1. Create component in `lib/shared/widgets/`
2. Follow existing component patterns
3. Support both light and dark themes
4. Use design system constants
5. Make components reusable and configurable

### Theming Guidelines

1. **Never hardcode colors**: Always use theme colors
2. **Test in both themes**: Ensure components work in light and dark modes
3. **Use semantic colors**: Choose colors based on meaning (success, error, etc.)
4. **Respect system preferences**: Support system theme when selected

## Testing

The design system includes tests for:

- Widget rendering in both themes
- Navigation functionality
- Provider state management
- Localization

Run tests:

```bash
flutter test
```

## Development

### Setup

```bash
cd mobile
flutter pub get
flutter gen-l10n
```

### Running the App

```bash
flutter run
```

### Building

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
```

## Screenshots

### Light Theme

The light theme uses a clean, minimal white background with zinc text colors and red accents for emergency actions.

### Dark Theme

The dark theme uses a deep zinc-950 background with appropriate contrast for readability while reducing eye strain in low-light conditions.

### Internationalization

The app seamlessly switches between English and Bengali, with all UI elements properly translated and formatted for each language.

## Future Enhancements

- [ ] Add more language support (Hindi, Spanish)
- [ ] Implement custom color scheme selection
- [ ] Add animation presets
- [ ] Create design system documentation site
- [ ] Add more reusable components (badges, chips, dialogs)
- [ ] Implement accessibility features (screen reader support, high contrast mode)

---

**Last Updated**: November 2025  
**Version**: 1.0.0
