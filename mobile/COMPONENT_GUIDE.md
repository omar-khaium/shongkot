# Component Usage Guide

This guide provides examples and best practices for using components in the Shongkot mobile app.

## Table of Contents

- [Buttons](#buttons)
- [Cards](#cards)
- [Text Fields](#text-fields)
- [Layout Patterns](#layout-patterns)
- [Theme Colors](#theme-colors)

## Buttons

### Primary Button

Use for main actions and CTAs:

```dart
import 'package:shongkot_app/shared/widgets/app_button.dart';

AppButton(
  text: 'Emergency SOS',
  onPressed: () {
    // Handle action
  },
  variant: ButtonVariant.primary,
)
```

### Secondary Button (Outlined)

Use for secondary actions:

```dart
AppButton(
  text: 'Add Contact',
  onPressed: () {},
  variant: ButtonVariant.secondary,
  icon: Icons.add,
)
```

### Ghost Button (Text)

Use for tertiary actions:

```dart
AppButton(
  text: 'Learn More',
  onPressed: () {},
  variant: ButtonVariant.ghost,
)
```

### Button Sizes

```dart
// Small button
AppButton(
  text: 'Small',
  onPressed: () {},
  size: ButtonSize.small,
)

// Medium button (default)
AppButton(
  text: 'Medium',
  onPressed: () {},
  size: ButtonSize.medium,
)

// Large button
AppButton(
  text: 'Large',
  onPressed: () {},
  size: ButtonSize.large,
)
```

### Full Width Button

```dart
AppButton(
  text: 'Continue',
  onPressed: () {},
  fullWidth: true,
)
```

### Loading State

```dart
AppButton(
  text: 'Saving...',
  onPressed: () {},
  isLoading: true,
)
```

## Cards

### Basic Card

```dart
import 'package:shongkot_app/shared/widgets/app_card.dart';
import 'package:shongkot_app/core/constants/app_spacing.dart';

AppCard(
  child: Column(
    children: [
      Text('Card Title', style: theme.textTheme.titleLarge),
      const SizedBox(height: AppSpacing.sm),
      Text('Card content goes here'),
    ],
  ),
)
```

### Interactive Card

```dart
AppCard(
  onTap: () {
    // Handle tap
  },
  child: Row(
    children: [
      Icon(Icons.person),
      const SizedBox(width: AppSpacing.md),
      Text('Tap me'),
    ],
  ),
)
```

### Card with Custom Padding

```dart
AppCard(
  padding: const EdgeInsets.all(AppSpacing.lg),
  child: Text('Custom padded content'),
)
```

### Card List Pattern

```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
  itemBuilder: (context, index) {
    return AppCard(
      child: ListTile(
        title: Text(items[index].title),
        subtitle: Text(items[index].subtitle),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  },
)
```

## Text Fields

### Basic Text Field

```dart
import 'package:shongkot_app/shared/widgets/app_text_field.dart';

AppTextField(
  label: 'Name',
  hint: 'Enter your name',
  controller: nameController,
)
```

### Text Field with Validation

```dart
AppTextField(
  label: 'Email',
  hint: 'your@email.com',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  },
)
```

### Password Field

```dart
AppTextField(
  label: 'Password',
  hint: 'Enter password',
  controller: passwordController,
  obscureText: true,
  suffixIcon: IconButton(
    icon: Icon(Icons.visibility),
    onPressed: () {
      // Toggle visibility
    },
  ),
)
```

### Multi-line Text Field

```dart
AppTextField(
  label: 'Message',
  hint: 'Enter your message',
  controller: messageController,
  maxLines: 4,
)
```

### Disabled Text Field

```dart
AppTextField(
  label: 'Username',
  controller: usernameController,
  enabled: false,
)
```

## Layout Patterns

### Screen Padding

Always use consistent padding for screens:

```dart
import 'package:shongkot_app/core/constants/app_spacing.dart';

Scaffold(
  body: Padding(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      children: [
        // Screen content
      ],
    ),
  ),
)
```

### Vertical Spacing

Use consistent spacing between elements:

```dart
Column(
  children: [
    Text('First item'),
    const SizedBox(height: AppSpacing.md),
    Text('Second item'),
    const SizedBox(height: AppSpacing.lg),
    Text('Third item'),
  ],
)
```

### Horizontal Spacing

```dart
Row(
  children: [
    Icon(Icons.person),
    const SizedBox(width: AppSpacing.sm),
    Text('Username'),
    const Spacer(),
    Icon(Icons.chevron_right),
  ],
)
```

### Section Headers

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Section Title',
      style: theme.textTheme.titleMedium,
    ),
    const SizedBox(height: AppSpacing.md),
    // Section content
  ],
)
```

## Theme Colors

### Getting Theme Colors

```dart
final theme = Theme.of(context);
final isDark = theme.brightness == Brightness.dark;

// Use theme colors
Color textColor = theme.colorScheme.onSurface;
Color primaryColor = theme.colorScheme.primary;
Color backgroundColor = theme.colorScheme.surface;
```

### Using Semantic Colors

```dart
import 'package:shongkot_app/core/constants/app_colors.dart';

// Success state
Container(
  color: AppColors.success.withValues(alpha: 0.1),
  child: Text(
    'Success message',
    style: TextStyle(color: AppColors.success),
  ),
)

// Warning state
Container(
  color: AppColors.warning.withValues(alpha: 0.1),
  child: Text(
    'Warning message',
    style: TextStyle(color: AppColors.warning),
  ),
)

// Error state
Container(
  color: AppColors.error.withValues(alpha: 0.1),
  child: Text(
    'Error message',
    style: TextStyle(color: AppColors.error),
  ),
)
```

### Conditional Theme Colors

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

Text(
  'Some text',
  style: TextStyle(
    color: isDark 
      ? AppColors.darkTextSecondary 
      : AppColors.lightTextSecondary,
  ),
)
```

## Icon Patterns

### Icon with Label

```dart
Column(
  children: [
    Icon(
      Icons.location_on,
      color: AppColors.success,
      size: 32,
    ),
    const SizedBox(height: AppSpacing.sm),
    Text(
      'Location',
      style: theme.textTheme.labelLarge,
    ),
  ],
)
```

### Icon Button

```dart
IconButton(
  icon: const Icon(Icons.settings),
  onPressed: () {},
)
```

### Leading Icon

```dart
Row(
  children: [
    Icon(Icons.phone, size: 20),
    const SizedBox(width: AppSpacing.sm),
    Text('Phone Number'),
  ],
)
```

## Status Indicators

### Badge

```dart
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
    vertical: AppSpacing.xs,
  ),
  decoration: BoxDecoration(
    color: AppColors.success.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
  ),
  child: Text(
    'ACTIVE',
    style: theme.textTheme.labelSmall?.copyWith(
      color: AppColors.success,
    ),
  ),
)
```

### Status Dot

```dart
Row(
  children: [
    Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
    ),
    const SizedBox(width: AppSpacing.sm),
    Text('Online'),
  ],
)
```

## List Patterns

### Simple List

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index].title),
      subtitle: Text(items[index].subtitle),
      onTap: () {},
    );
  },
)
```

### Card List with Dividers

```dart
AppCard(
  padding: EdgeInsets.zero,
  child: Column(
    children: [
      ListTile(title: Text('Item 1')),
      Divider(height: 1),
      ListTile(title: Text('Item 2')),
      Divider(height: 1),
      ListTile(title: Text('Item 3')),
    ],
  ),
)
```

## Dialog Patterns

### Simple Dialog

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm Action'),
    content: Text('Are you sure you want to continue?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(l10n.cancel),
      ),
      ElevatedButton(
        onPressed: () {
          // Perform action
          Navigator.pop(context);
        },
        child: Text(l10n.confirm),
      ),
    ],
  ),
)
```

### Bottom Sheet

```dart
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Options',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Delete'),
          onTap: () {},
        ),
      ],
    ),
  ),
)
```

## Localization

### Using Translations

```dart
import 'package:shongkot_app/l10n/app_localizations.dart';

final l10n = AppLocalizations.of(context)!;

Text(l10n.appTitle)
Text(l10n.emergencyContacts)
Text(l10n.settings)
```

### Theme-aware Text

```dart
Text(
  l10n.appTitle,
  style: theme.textTheme.headlineMedium,
)
```

## Best Practices

1. **Always use design system components** instead of raw Material widgets
2. **Use spacing constants** from `app_spacing.dart`
3. **Use theme colors** instead of hardcoded colors
4. **Support both light and dark themes** in all components
5. **Use localization** for all user-facing text
6. **Follow Material 3 guidelines** for component behavior
7. **Test components in both themes** before committing
8. **Keep components simple and focused** on single responsibility
9. **Document custom components** with usage examples
10. **Use semantic naming** for better code readability

---

**Last Updated**: November 2025  
**Version**: 1.0.0
