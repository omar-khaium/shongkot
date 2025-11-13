# Branch Management Strategy

## Overview

This document describes the branch management strategy for the Shongkot project. The strategy is designed to enable independent development of mobile and backend components while maintaining a stable main branch for production releases.

---

## Branch Structure

### Main Branch (`main`)

**Purpose:** Production-ready code containing the most stable version of both mobile and backend.

**Characteristics:**
- Protected branch (requires PR approval)
- Contains fully tested and integrated code
- Source for production deployments
- Updated only from stable mobile/backend branches
- Full CI/CD pipeline runs (both mobile and backend)

**Update Frequency:** After mobile/backend branches are stable and tested

**Deployment:** Triggers deployment of both mobile app and backend API

---

### Mobile Branch (`mobile`)

**Purpose:** Latest stable mobile application code with all recent mobile features.

**Characteristics:**
- Contains mobile directory code only
- Mobile feature PRs merge here first
- Mobile-only CI/CD pipeline runs
- Backend CI/CD does NOT run
- Periodically merged to `main` after thorough testing

**Workflow:**
```
feature/mobile-xyz → mobile branch → main branch
```

**CI/CD Behavior:**
- ✅ Frontend CI/CD runs (analyze, test, build, deploy)
- ❌ Backend CI/CD does NOT run
- Updates: Mobile APK/AAB to Firebase App Distribution

---

### Backend Branch (`backend`)

**Purpose:** Latest stable backend API code with all recent backend features.

**Characteristics:**
- Contains backend directory code only
- Backend feature PRs merge here first
- Backend-only CI/CD pipeline runs
- Frontend CI/CD does NOT run
- Periodically merged to `main` after thorough testing

**Workflow:**
```
feature/backend-abc → backend branch → main branch
```

**CI/CD Behavior:**
- ✅ Backend CI/CD runs (build, test, docker, deploy)
- ❌ Frontend CI/CD does NOT run
- Updates: Backend API deployment to Cloud Run

---

## Development Workflow

### For Mobile Development

1. **Create Feature Branch**
   ```bash
   git checkout mobile
   git pull origin mobile
   git checkout -b feature/mobile-feature-name
   ```

2. **Develop and Test Locally**
   ```bash
   cd mobile
   flutter test
   flutter run
   ```

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add mobile feature"
   git push origin feature/mobile-feature-name
   ```

4. **Create Pull Request**
   - Base: `mobile` branch
   - Title: Clear description of changes
   - Description: What was changed and why
   - Wait for CI/CD and review

5. **After Merge**
   - Feature branch is deleted
   - Changes are now in `mobile` branch
   - Mobile CI/CD runs automatically
   - App is deployed to Firebase App Distribution

### For Backend Development

1. **Create Feature Branch**
   ```bash
   git checkout backend
   git pull origin backend
   git checkout -b feature/backend-feature-name
   ```

2. **Develop and Test Locally**
   ```bash
   cd backend
   dotnet test
   dotnet run --project Shongkot.Api
   ```

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add backend feature"
   git push origin feature/backend-feature-name
   ```

4. **Create Pull Request**
   - Base: `backend` branch
   - Title: Clear description of changes
   - Description: What was changed and why
   - Wait for CI/CD and review

5. **After Merge**
   - Feature branch is deleted
   - Changes are now in `backend` branch
   - Backend CI/CD runs automatically
   - API is deployed to Google Cloud Run

### Merging to Main

When mobile or backend branch is stable and tested:

1. **Create Pull Request to Main**
   ```bash
   # For mobile
   git checkout main
   git pull origin main
   git checkout -b merge/mobile-to-main
   git merge mobile
   git push origin merge/mobile-to-main
   
   # For backend
   git checkout main
   git pull origin main
   git checkout -b merge/backend-to-main
   git merge backend
   git push origin merge/backend-to-main
   ```

2. **Review and Test**
   - Full CI/CD runs (both mobile and backend)
   - All tests must pass
   - Manual QA testing recommended
   - Review by maintainers

3. **After Merge**
   - Main branch updated with latest stable code
   - Production deployment triggered
   - Both mobile and backend deployed

---

## CI/CD Pipeline Behavior

### Mobile Branch CI/CD

**Triggered by:**
- Push to `mobile` branch
- Pull request to `mobile` branch
- Changes in `mobile/**` directory

**Pipeline Jobs:**
- ✅ Code analysis and formatting
- ✅ Unit tests
- ✅ Widget tests
- ✅ Build APK/AAB
- ✅ Deploy to Firebase App Distribution
- ✅ Create GitHub release
- ❌ Backend build/test/deploy (skipped)

### Backend Branch CI/CD

**Triggered by:**
- Push to `backend` branch
- Pull request to `backend` branch
- Changes in `backend/**` directory

**Pipeline Jobs:**
- ✅ Build and restore
- ✅ Unit tests
- ✅ Integration tests
- ✅ Docker build
- ✅ Deploy to Google Cloud Run
- ✅ Update README
- ❌ Mobile build/test/deploy (skipped)

### Main Branch CI/CD

**Triggered by:**
- Push to `main` branch
- Pull request to `main` branch

**Pipeline Jobs:**
- ✅ All mobile pipeline jobs (if mobile changes)
- ✅ All backend pipeline jobs (if backend changes)
- ✅ Full integration testing
- ✅ Production deployments

---

## Branch Protection Rules

### Main Branch
- ✅ Require pull request reviews (1 approval)
- ✅ Require status checks to pass
- ✅ Require branches to be up to date
- ✅ Include administrators
- ✅ Require linear history

### Mobile Branch
- ✅ Require pull request reviews
- ✅ Require status checks to pass (mobile CI/CD)
- ✅ Require branches to be up to date
- ✅ Allow force pushes (by maintainers only)

### Backend Branch
- ✅ Require pull request reviews
- ✅ Require status checks to pass (backend CI/CD)
- ✅ Require branches to be up to date
- ✅ Allow force pushes (by maintainers only)

---

## Feature Branch Naming Conventions

### Mobile Features
```
feature/mobile-<description>
fix/mobile-<description>
hotfix/mobile-<description>
refactor/mobile-<description>
```

Examples:
- `feature/mobile-emergency-button`
- `fix/mobile-location-tracking`
- `hotfix/mobile-crash-on-launch`

### Backend Features
```
feature/backend-<description>
fix/backend-<description>
hotfix/backend-<description>
refactor/backend-<description>
```

Examples:
- `feature/backend-emergency-api`
- `fix/backend-auth-validation`
- `hotfix/backend-database-connection`

### Full-Stack Features
```
feature/fullstack-<description>
```

These should be broken into separate mobile and backend PRs when possible.

---

## Commit Message Conventions

Follow conventional commits format:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Scopes
- `mobile`: Mobile application changes
- `backend`: Backend API changes
- `cicd`: CI/CD pipeline changes
- `docs`: Documentation changes

### Examples
```
feat(mobile): add emergency SOS button
fix(backend): resolve database connection timeout
docs(wiki): update deployment instructions
chore(cicd): update Flutter version to 3.35.3
```

---

## Handling Conflicts

### Mobile-Backend Conflicts

Since mobile and backend develop independently, conflicts are rare. When they occur:

1. **API Contract Changes**
   - Update backend API first
   - Deploy to staging/test environment
   - Update mobile to use new API
   - Test integration thoroughly
   - Merge both to main together

2. **Shared Configuration**
   - Coordinate changes in advance
   - Update both branches simultaneously
   - Test in development environment first

### Merge Conflicts

When merging mobile/backend to main:

1. **Update feature branch**
   ```bash
   git checkout feature-branch
   git merge main
   # Resolve conflicts
   git commit
   git push
   ```

2. **Communicate with team**
   - Notify in PR comments
   - Discuss resolution approach
   - Request review after resolution

---

## Release Process

### Versioning

Use semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

### Release Steps

1. **Prepare Release**
   - Ensure mobile and backend branches are stable
   - All tests passing
   - Documentation updated

2. **Create Release Branch**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b release/v1.0.0
   ```

3. **Version Bump**
   - Update version in `mobile/pubspec.yaml`
   - Update version in `backend/Shongkot.Api/Shongkot.Api.csproj`
   - Update CHANGELOG.md

4. **Create Tag**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

5. **Deploy**
   - Merge release branch to main
   - CI/CD deploys automatically
   - Monitor deployments

6. **Post-Release**
   - Create GitHub release with notes
   - Notify testers
   - Announce in channels

---

## Emergency Hotfixes

For critical production issues:

1. **Create Hotfix Branch from Main**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b hotfix/critical-bug
   ```

2. **Fix and Test**
   - Make minimal changes
   - Test thoroughly
   - Update tests

3. **Merge to Main Immediately**
   - Skip mobile/backend branches
   - Create PR to main
   - Expedited review process
   - Deploy immediately

4. **Backport to Feature Branches**
   ```bash
   git checkout mobile
   git merge hotfix/critical-bug
   git push
   
   git checkout backend
   git merge hotfix/critical-bug
   git push
   ```

---

## Best Practices

### DO ✅

- Keep feature branches small and focused
- Test locally before pushing
- Write clear commit messages
- Update documentation with code changes
- Run CI/CD checks locally before PR
- Communicate with team about major changes
- Review code thoroughly
- Merge mobile/backend to main regularly

### DON'T ❌

- Don't push directly to main/mobile/backend
- Don't merge without PR review
- Don't skip tests
- Don't create long-lived feature branches
- Don't mix mobile and backend changes in one PR
- Don't ignore CI/CD failures
- Don't force push to shared branches
- Don't merge broken code

---

## Troubleshooting

### CI/CD Not Triggering

**Problem:** Pipeline doesn't run on push

**Solution:**
- Check branch name matches trigger pattern
- Verify changes are in correct directory
- Check GitHub Actions tab for errors
- Verify secrets are configured

### Tests Failing

**Problem:** Tests pass locally but fail in CI/CD

**Solution:**
- Check environment differences
- Verify all dependencies installed
- Check for hardcoded paths/values
- Review CI/CD logs carefully

### Merge Conflicts

**Problem:** Cannot merge due to conflicts

**Solution:**
- Update branch with latest main/mobile/backend
- Resolve conflicts carefully
- Test after resolution
- Request review if unsure

---

## Support

For questions or issues with the branch strategy:

1. Check this documentation
2. Review related docs (WIKI.md, CONTRIBUTING.md)
3. Ask in team channels
4. Contact maintainers

**Maintainer:** [@omar-khaium](https://github.com/omar-khaium)

---

**Last Updated:** 2025-11-13
