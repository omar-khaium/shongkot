# Quick Start Guide - Mobile App Development

This is a quick reference guide for developers working on the Shongkot mobile app. For detailed information, see [MOBILE_APP_DEVELOPMENT_PLAN.md](MOBILE_APP_DEVELOPMENT_PLAN.md).

## 🎯 Current Status

**Phase**: Foundation & Core Features (Phase 1)  
**Goal**: Authentication, Location Services, API Integration  
**Timeline**: Weeks 1-4

## 🚀 Getting Started

### 1. Setup Development Environment

```bash
# Clone repository
git clone https://github.com/omar-khaium/shongkot.git
cd shongkot

# Setup git hooks
./setup-dev.sh

# Navigate to mobile directory
cd mobile

# Install Flutter dependencies
flutter pub get

# Run the app
flutter run
```

### 2. Check GitHub Project Board

Visit: [GitHub Projects](https://github.com/omar-khaium/shongkot/projects)
- View current sprint tasks
- Check your assigned issues
- Update issue status as you work

### 3. Pick an Issue

Filter for issues ready for development:
```
is:open label:"phase-1: foundation" no:assignee
```

Or check the **Ready for Development** column in the project board.

## 📋 Development Workflow

### Step 1: Assign Issue
- Assign issue to yourself
- Move to "In Progress" column
- Read all acceptance criteria

### Step 2: Create Branch
```bash
# Create feature branch from mobile
git checkout mobile
git pull origin mobile
git checkout -b feature/short-description

# Example: git checkout -b feature/user-registration
```

### Step 3: Implement Feature
- Write code following existing patterns
- Add unit tests for business logic
- Add widget tests for UI components
- Run linter: `flutter analyze`
- Format code: `dart format lib/ test/`

### Step 4: Test
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/auth_test.dart
```

### Step 5: Create Pull Request
```bash
# Commit changes
git add .
git commit -m "feat(auth): implement user registration

- Add registration form with validation
- Implement Firebase Auth integration
- Add unit tests for validation logic
- Add widget tests for form

Fixes #123"

# Push to origin
git push origin feature/short-description
```

Then create PR on GitHub:
- Title: "feat(auth): implement user registration"
- Description: Link to issue, describe changes, add screenshots
- Link issue: "Fixes #123"
- Request review

### Step 6: Address Review Comments
- Make requested changes
- Push updates to same branch
- Re-request review when ready

### Step 7: Merge
- Wait for approval and CI to pass
- Squash and merge to `mobile` branch
- Delete feature branch

## 🏗️ Project Structure

```
mobile/lib/
├── core/                      # Core app functionality
│   ├── constants/            # Design system constants
│   ├── theme/                # Theme configuration
│   ├── providers/            # Global state providers
│   └── navigation/           # Navigation setup
├── features/                 # Feature modules
│   ├── auth/                # Authentication feature (TO BUILD)
│   │   ├── data/            # API clients, repositories
│   │   ├── domain/          # Entities, interfaces
│   │   └── presentation/    # Screens, widgets, state
│   ├── emergency/           # Emergency system (PARTIALLY BUILT)
│   ├── contacts/            # Contacts management (BASIC)
│   ├── responders/          # Responders finder (BASIC)
│   ├── settings/            # App settings (BASIC)
│   └── [new_feature]/       # New feature module
├── shared/                   # Shared widgets and utilities
│   └── widgets/             # Reusable UI components
└── l10n/                    # Localization files
```

## 🎨 Design System

We follow a **shadcn-inspired minimal design system**.

### Colors
```dart
// Light Theme
AppColors.background    // #FFFFFF
AppColors.primary       // #DC2626 (red)
AppColors.text          // #18181B

// Dark Theme
AppColors.backgroundDark // #09090B
AppColors.primaryDark    // #EF4444 (brighter red)
AppColors.textDark       // #FAFAFA
```

### Typography
```dart
AppTypography.h1          // 28px, Bold - Page titles
AppTypography.h2          // 24px, Semibold - Section titles
AppTypography.bodyLarge   // 16px, Regular - Primary content
AppTypography.bodyMedium  // 14px, Regular - Secondary content
```

### Spacing
```dart
AppSpacing.xs    // 4px
AppSpacing.sm    // 8px
AppSpacing.md    // 16px
AppSpacing.lg    // 24px
AppSpacing.xl    // 32px
```

### Components
```dart
// Button
AppButton(
  text: 'Submit',
  onPressed: () {},
  variant: ButtonVariant.primary, // primary, secondary, ghost
  size: ButtonSize.medium,        // small, medium, large
)

// Card
AppCard(
  child: Text('Content'),
  onTap: () {},
)

// Text Field
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
)
```

## 📝 Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting, no code change
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Examples:**
```bash
feat(auth): add biometric login support
fix(emergency): prevent duplicate submissions
docs(readme): update setup instructions
refactor(api): extract http client to separate file
test(auth): add unit tests for login validation
```

## 🧪 Testing Guidelines

### Unit Tests
Test business logic, validators, utilities:
```dart
test('validates email format', () {
  final result = EmailValidator.validate('test@example.com');
  expect(result, isTrue);
});
```

### Widget Tests
Test UI components and screens:
```dart
testWidgets('displays error when email is invalid', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.enterText(find.byType(TextField), 'invalid-email');
  await tester.tap(find.byType(AppButton));
  await tester.pump();
  
  expect(find.text('Invalid email'), findsOneWidget);
});
```

### Integration Tests
Test complete user flows:
```dart
testWidgets('user can register and login', (tester) async {
  // Full registration and login flow
});
```

## 📚 Key Documents

- **[MOBILE_APP_DEVELOPMENT_PLAN.md](MOBILE_APP_DEVELOPMENT_PLAN.md)** - Complete development plan
- **[GITHUB_PROJECTS_SETUP.md](GITHUB_PROJECTS_SETUP.md)** - GitHub Projects guide
- **[mobile/README.md](mobile/README.md)** - Mobile app specific docs
- **[mobile/DESIGN_SYSTEM.md](mobile/DESIGN_SYSTEM.md)** - Design system details
- **[mobile/COMPONENT_GUIDE.md](mobile/COMPONENT_GUIDE.md)** - Component usage

## 🔧 Common Commands

```bash
# Development
flutter run                    # Run app
flutter run --release          # Run in release mode
flutter run -d chrome          # Run on Chrome
flutter hot-reload            # Hot reload (r in terminal)
flutter hot-restart           # Hot restart (R in terminal)

# Testing
flutter test                   # Run all tests
flutter test --coverage       # With coverage report
flutter test test/unit/       # Run unit tests only

# Code Quality
flutter analyze               # Run static analysis
dart format lib/ test/        # Format code
flutter pub outdated          # Check for updates

# Building
flutter build apk             # Build APK
flutter build appbundle       # Build App Bundle
flutter build ios             # Build iOS (macOS only)

# Cleaning
flutter clean                 # Clean build files
flutter pub get               # Get dependencies
```

## 🚨 Common Issues

### Issue: Flutter command not found
```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"

# Or install Flutter: https://flutter.dev/docs/get-started/install
```

### Issue: Build fails with dependency errors
```bash
# Clean and reinstall
flutter clean
flutter pub get
flutter pub upgrade
```

### Issue: Tests fail with provider errors
```dart
// Wrap test widget with ProviderScope
testWidgets('test name', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: MyWidget()),
    ),
  );
});
```

### Issue: Hot reload not working
```bash
# Do a hot restart instead (R in terminal)
# Or stop and restart the app
```

## 📞 Getting Help

### Questions about:
- **Code/Implementation**: Open a discussion or ask in PR comments
- **Design**: Check DESIGN_SYSTEM.md or ask in issue
- **Process**: Check GITHUB_PROJECTS_SETUP.md
- **Setup**: Check mobile/README.md

### Resources:
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)
- [Project Discussions](https://github.com/omar-khaium/shongkot/discussions)

## ⚡ Quick Tips

1. **Run tests early and often** - Catch issues before they grow
2. **Use hot reload** - Faster iteration during development
3. **Follow the design system** - Keep UI consistent
4. **Write descriptive commit messages** - Help others understand changes
5. **Ask questions** - Better to ask than implement incorrectly
6. **Review your own PRs** - Catch mistakes before others review
7. **Keep PRs focused** - One feature/fix per PR
8. **Update documentation** - If you change behavior, update docs

## 🎯 Current Sprint (Week 1-2)

### Priority Features
1. User Registration Flow
2. SMS/Email Verification
3. Login with Biometric Support
4. GPS Location Tracking
5. API Client Setup

### Team Focus
- **Authentication**: Critical for all other features
- **Location Services**: Core to emergency functionality
- **API Integration**: Foundation for backend communication

---

**Ready to start?** Pick an issue from the board and follow the workflow above!

**Need help?** Check the detailed docs or ask in Discussions.

**Happy coding! 🚀**
