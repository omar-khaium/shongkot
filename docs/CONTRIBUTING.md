# Contributing to Shongkot

Thank you for your interest in contributing to Shongkot! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Respect different viewpoints and experiences

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in Issues
2. Use the bug report template
3. Include:
   - Clear description of the issue
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - Environment details (OS, browser, versions)

### Suggesting Enhancements

1. Check if the enhancement has already been suggested
2. Use the feature request template
3. Explain:
   - The problem you're trying to solve
   - Your proposed solution
   - Alternative solutions considered
   - Additional context

### Pull Requests

1. **Fork and Branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes:**
   - Follow coding standards (see below)
   - Write/update tests
   - Update documentation

3. **Test Thoroughly:**
   ```bash
   # Backend
   cd backend && dotnet test
   
   # Frontend
   cd mobile && flutter test
   ```

4. **Commit:**
   
   ⚠️ **Important:** The pre-commit hook will automatically check:
   - Code formatting (dart format / dotnet format)
   - Lint errors (flutter analyze)
   
   If issues are found, the commit will be **blocked** until you fix them.
   
   ```bash
   git commit -m "feat: add awesome feature"
   ```
   
   Follow [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `test:` Adding or updating tests
   - `refactor:` Code refactoring
   - `style:` Code style changes
   - `perf:` Performance improvements
   - `chore:` Maintenance tasks

5. **Push and Create PR:**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a Pull Request on GitHub.

## Coding Standards

### Backend (C#)

- Follow [C# Coding Conventions](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- Use PascalCase for public members
- Use camelCase for private fields with `_` prefix
- Add XML documentation for public APIs
- Keep methods focused and small
- Write unit tests for business logic (> 80% coverage)

**Example:**
```csharp
/// <summary>
/// Triggers an emergency alert
/// </summary>
/// <param name="request">Emergency request details</param>
/// <returns>Created emergency</returns>
public ActionResult<Emergency> TriggerEmergency(CreateEmergencyRequest request)
{
    // Implementation
}
```

### Frontend (Dart/Flutter)

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use lowerCamelCase for identifiers
- Use UpperCamelCase for types
- Prefer const constructors when possible
- Use meaningful variable names
- Write widget tests for UI components
- Follow Clean Architecture pattern

**Example:**
```dart
class EmergencyButton extends StatelessWidget {
  const EmergencyButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Implementation
  }
}
```

## Testing Requirements

### Minimum Coverage
- Backend: 80% code coverage
- Frontend: 75% code coverage

### Test Types Required

1. **Unit Tests:**
   - Test business logic
   - Test edge cases
   - Test error handling

2. **Integration Tests:**
   - Test API endpoints
   - Test database operations
   - Test external service integrations

3. **Widget Tests (Frontend):**
   - Test UI components
   - Test user interactions
   - Test state changes

4. **E2E Tests (Frontend):**
   - Test critical user flows
   - Test emergency trigger flow
   - Test contact management

## Documentation

- Update README.md if needed
- Add inline code comments for complex logic
- Update API documentation (Swagger)
- Update SETUP.md for new dependencies or setup steps

## Review Process

1. **Automated Checks:**
   - All CI/CD tests must pass
   - Code coverage requirements met
   - No security vulnerabilities
   - Code formatting is correct (enforced by pre-commit hook)
   - No lint errors (enforced by pre-commit hook)
   
   ⚠️ **Note:** If you set up the pre-commit hook correctly (via `./setup-dev.sh`), 
   formatting and lint issues will be caught **before** you commit, so CI/CD 
   should not fail for these reasons.

2. **Manual Review:**
   - Code quality and readability
   - Architecture consistency
   - Test quality
   - Documentation completeness

3. **Approval:**
   - At least one approval required
   - All comments addressed
   - No unresolved conversations

## Development Setup

### Initial Setup

1. **Clone and Setup:**
   ```bash
   git clone https://github.com/omar-khaium/shongkot.git
   cd shongkot
   ./setup-dev.sh
   ```

   The setup script will:
   - Configure git hooks to enforce code quality
   - Set up pre-commit checks for formatting and linting
   - Ensure no commits with code quality issues

2. **Install Dependencies:**
   
   **Backend:**
   ```bash
   cd backend
   dotnet restore
   ```
   
   **Mobile:**
   ```bash
   cd mobile
   flutter pub get
   ```

### Pre-commit Checks

The project uses git hooks to **automatically enforce** code quality before commits:

#### What Gets Checked:
- ✅ **Code Formatting** (Dart/C#)
- ✅ **Lint Errors** (flutter analyze / dotnet format)

#### Behavior:
- ❌ **Commits are blocked** if formatting issues or lint errors are found
- ✅ CI/CD will **not fail** due to code quality issues (they're caught locally)

#### Manual Checks:
Run these commands before committing to fix issues:

```bash
# Flutter/Dart
cd mobile
dart format .              # Fix formatting
flutter analyze            # Check for lint errors

# C# (Backend)
cd backend
dotnet format              # Fix formatting
```

### Bypassing Pre-commit Hooks (Not Recommended)

If you absolutely must bypass the pre-commit hook:
```bash
git commit --no-verify -m "your message"
```
⚠️ **Warning:** Your PR may be rejected if CI checks fail.

See [SETUP.md](SETUP.md) for detailed setup instructions.

## Questions?

- Open a discussion on GitHub
- Check existing issues and PRs
- Review documentation

Thank you for contributing to Shongkot! 🚨
