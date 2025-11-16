# Contributing to Shongkot

Thank you for your interest in contributing to the Shongkot Emergency Responder project!

## Getting Started

### Prerequisites

- **Backend**: .NET 9.0 SDK
- **Mobile**: Flutter 3.35.3+, Dart 3.0+
- Git

### Setting Up Your Development Environment

1. **Clone the repository**
   ```bash
   git clone https://github.com/omar-khaium/shongkot.git
   cd shongkot
   ```

2. **Install Git Hooks (Recommended)**
   
   We provide pre-commit hooks that automatically check code formatting before commits:
   
   ```bash
   ./scripts/install-git-hooks.sh
   ```
   
   Or manually configure:
   ```bash
   git config core.hooksPath .githooks
   ```
   
   This will ensure your Dart code is properly formatted before each commit.

3. **Backend Setup**
   ```bash
   cd backend
   dotnet restore
   dotnet build
   ```

4. **Mobile Setup**
   ```bash
   cd mobile
   flutter pub get
   ```

## Code Style and Formatting

### Mobile (Flutter/Dart)

- **Formatting**: We use `dart format` to maintain consistent code style
- **Before committing**: Run `dart format .` in the `mobile` directory
- **With git hooks**: Formatting is checked automatically on commit
- **CI/CD**: Pull requests will be automatically formatted by our CI system

Run formatting manually:
```bash
cd mobile
dart format .
```

Check if code is formatted:
```bash
cd mobile
dart format --output=none --set-exit-if-changed .
```

### Backend (C#)

- Follow C# coding conventions
- Use meaningful variable names
- Add XML documentation for public APIs

## Making Changes

1. **Create a branch** from the appropriate base:
   - Backend changes: branch from `backend`
   - Mobile changes: branch from `mobile`
   - Cross-cutting: branch from `main`

2. **Make your changes**
   - Write clear, concise code
   - Add tests for new features
   - Update documentation as needed

3. **Format your code**
   - Mobile: `cd mobile && dart format .`
   - Backend: Use your IDE's formatter

4. **Test your changes**
   - Backend: `cd backend && dotnet test`
   - Mobile: `cd mobile && flutter test`

5. **Commit your changes**
   - Use conventional commit messages: `feat:`, `fix:`, `docs:`, etc.
   - Pre-commit hook will check formatting automatically

6. **Push and create a Pull Request**
   - Our CI will run automated checks
   - Auto-formatting will be applied if needed
   - Address any review feedback

## Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks
- `ci:` - CI/CD changes

Examples:
```
feat: add Google sign-in support
fix: resolve token refresh issue
docs: update API documentation
```

## Pull Request Process

1. **Ensure CI passes**: All automated checks must pass
2. **Auto-formatting**: If your code isn't formatted, our CI will automatically format and push changes
3. **Code review**: Wait for maintainer review
4. **Address feedback**: Make requested changes
5. **Merge**: Maintainers will merge approved PRs

## Testing

### Backend Tests
```bash
cd backend
dotnet test
dotnet test --collect:"XPlat Code Coverage"
```

### Mobile Tests
```bash
cd mobile
flutter test
flutter test --coverage
```

## Need Help?

- Check existing issues and documentation
- Create an issue for bugs or feature requests
- Join discussions in pull requests

## Code of Conduct

- Be respectful and professional
- Welcome newcomers
- Focus on constructive feedback
- Help maintain a positive community

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
