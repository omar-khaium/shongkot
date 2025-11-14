# Git Hooks for Shongkot

This directory contains git hooks that enforce code quality standards before commits are allowed.

## Setup

Run the setup script from the repository root:

```bash
./setup-dev.sh
```

This configures git to use hooks from this directory.

## Pre-commit Hook

The `pre-commit` hook runs automatically before each commit and checks:

### For Flutter/Dart Files (mobile/)
1. **Code Formatting**: Runs `dart format --set-exit-if-changed`
   - Ensures all code follows Dart formatting conventions
   - Blocks commit if formatting issues are found
   - Fix with: `cd mobile && dart format .`

2. **Lint Analysis**: Runs `flutter analyze`
   - Checks for code quality issues and potential bugs
   - Blocks commit if lint errors are found
   - Fix with: `cd mobile && flutter analyze` and address issues

### For C# Files (backend/)
1. **Code Formatting**: Runs `dotnet format --verify-no-changes`
   - Ensures all code follows C# formatting conventions
   - Blocks commit if formatting issues are found
   - Fix with: `cd backend && dotnet format`

## Bypassing Hooks (Not Recommended)

If you need to bypass the pre-commit hook:

```bash
git commit --no-verify -m "your message"
```

⚠️ **Warning**: 
- Use this only in emergencies
- Your PR may be rejected if CI checks fail
- You're responsible for fixing any issues before merge

## Benefits

✅ **Catches issues early**: Problems are found before they reach CI/CD
✅ **Faster feedback**: No waiting for CI to fail
✅ **Cleaner git history**: No "fix lint" commits
✅ **Better collaboration**: Consistent code quality across the team

## Troubleshooting

### Hook not running
```bash
# Re-run setup
./setup-dev.sh

# Verify configuration
git config core.hooksPath
# Should output: .githooks
```

### Hook failing
1. Read the error message carefully
2. Run the suggested fix command
3. Stage the fixed files: `git add .`
4. Try committing again

### Dependencies missing
- **Flutter not found**: Install Flutter from https://flutter.dev/docs/get-started/install
- **.NET not found**: Install .NET SDK from https://dotnet.microsoft.com/download

## Custom Hooks

To add more hooks, create executable scripts in this directory:
- `pre-push` - Runs before pushing to remote
- `commit-msg` - Validates commit messages
- `pre-rebase` - Runs before rebasing

See: https://git-scm.com/docs/githooks
