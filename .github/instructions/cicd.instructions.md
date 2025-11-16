---
applies_to: .github/workflows/
---

# CI/CD Workflow Instructions

## Workflow Structure

The project uses GitHub Actions for CI/CD with separate workflows for backend and mobile:

- `backend-cicd.yml` - Backend build, test, and deployment
- `frontend-cicd.yml` - Mobile build, test, and distribution
- `branch-sync.yml` - Branch synchronization

## Backend CI/CD (`backend-cicd.yml`)

### Triggers
- Push to `main` or `backend` branches
- Pull requests targeting `main` or `backend`
- Path filter: `backend/**` or workflow file changes

### Jobs
1. **build-and-test**: Build and run tests with coverage
2. **deploy**: Deploy to Google Cloud Run (main branch only)

### Environment
- .NET SDK: 9.0.x
- Runner: ubuntu-latest

### Key Commands
```yaml
dotnet restore
dotnet build --configuration Release
dotnet test --collect:"XPlat Code Coverage"
```

### Secrets Required
- `GCP_PROJECT_ID`: Google Cloud project ID
- `GCP_SA_KEY`: Service account key for Cloud Run
- `GCP_REGION`: Deployment region

## Mobile CI/CD (`frontend-cicd.yml`)

### Triggers
- Push to `main` or `mobile` branches
- Pull requests targeting `main` or `mobile`
- Path filter: `mobile/**` or workflow file changes

### Jobs
1. **analyze-and-test**: Analyze and test Flutter app
2. **build-and-distribute**: Build APK and distribute via Firebase

### Environment
- Flutter: 3.35.3 (stable channel)
- Runner: ubuntu-latest

### Key Commands
```yaml
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --coverage
flutter build apk --release
```

### Secrets Required
- `FIREBASE_PROJECT_ID`: Firebase project ID
- `FIREBASE_TOKEN`: Firebase CI token
- `FIREBASE_APP_ID`: Firebase Android app ID
- `FIREBASE_SERVICE_CREDENTIALS`: Service account JSON

## Modifying Workflows

### Adding New Steps

When adding steps to workflows:

1. **Place appropriately**: Add build steps to build jobs, test steps to test jobs
2. **Use caching**: Cache dependencies when possible
3. **Set timeouts**: Add `timeout-minutes` to prevent hanging jobs
4. **Handle errors**: Use `continue-on-error` for non-critical steps
5. **Add conditions**: Use `if:` to control when steps run

Example:
```yaml
- name: New Step
  if: success()
  timeout-minutes: 10
  run: command
  continue-on-error: false
```

### Adding Environment Variables

Add to the `env:` section at job or workflow level:
```yaml
env:
  MY_VAR: value
  ANOTHER_VAR: ${{ secrets.SECRET_NAME }}
```

### Path Filtering

Update `paths:` to trigger on relevant file changes:
```yaml
on:
  push:
    branches: [ main ]
    paths:
      - 'backend/**'
      - 'shared/**'
      - '.github/workflows/backend-cicd.yml'
```

## Branch Sync Workflow (`branch-sync.yml`)

### Purpose
Synchronizes changes from feature branches to appropriate base branches:
- Mobile features → `mobile` branch
- Backend features → `backend` branch

### Configuration
```yaml
on:
  push:
    branches:
      - 'mobile/**'
      - 'backend/**'
```

## Secrets Management

### Adding Secrets
1. Go to repository Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add name and value
4. Use in workflows: `${{ secrets.SECRET_NAME }}`

### Secret Naming Convention
- Use UPPERCASE_WITH_UNDERSCORES
- Group by service: `GCP_*`, `FIREBASE_*`, `AZURE_*`
- Be descriptive: `FIREBASE_SERVICE_CREDENTIALS` not `FIREBASE_CREDS`

## Testing Workflows Locally

Use [act](https://github.com/nektos/act) to test workflows locally:

```bash
# Install act
brew install act  # macOS
# or
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run workflow
act push -W .github/workflows/backend-cicd.yml

# Run specific job
act -j build-and-test
```

## Workflow Best Practices

1. **Keep jobs focused**: One responsibility per job
2. **Use matrix builds**: Test multiple versions/platforms
3. **Cache dependencies**: Speed up builds
4. **Fail fast**: Don't continue if critical steps fail
5. **Use artifacts**: Share data between jobs
6. **Monitor workflows**: Review logs and failures
7. **Update regularly**: Keep actions up to date

## Debugging Workflows

### Enable Debug Logging
Add to workflow file:
```yaml
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true
```

### Common Issues

**Workflow not triggering:**
- Check branch names match triggers
- Verify path filters include changed files
- Ensure workflow file is in `main` branch

**Secrets not available:**
- Verify secret names match exactly
- Check repository has access to secrets
- Ensure secrets are set at correct scope

**Build failures:**
- Check runner OS matches requirements
- Verify all dependencies are available
- Review environment setup steps
- Check for version mismatches

## Code Coverage Integration

### Backend (Codecov)
```yaml
- name: Upload coverage
  uses: codecov/codecov-action@v3
  with:
    files: ./coverage/coverage.cobertura.xml
    flags: backend
```

### Mobile (Codecov)
```yaml
- name: Upload coverage
  uses: codecov/codecov-action@v3
  with:
    files: ./mobile/coverage/lcov.info
    flags: mobile
```

## Before Committing Workflow Changes

1. Validate YAML syntax
2. Test locally with `act` if possible
3. Start with small changes
4. Monitor first run carefully
5. Have rollback plan ready
6. Document changes in commit message

## Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [.NET CI/CD with GitHub Actions](https://docs.microsoft.com/dotnet/devops/github-actions-overview)
