# CI/CD Security and Permissions

This document explains the security configuration and permissions for the GitHub Actions workflows in this repository.

## Overview

The repository uses GitHub Actions for continuous integration and deployment. We follow the **principle of least privilege** to ensure workflows have only the permissions they need to function, minimizing security risks.

## Backend CI/CD Workflow Permissions

### Workflow-Level Permissions

The backend CI/CD workflow (`backend-cicd.yml`) has default read-only permissions:

```yaml
permissions:
  contents: read  # Allow reading repository contents for checkout
```

This sets a secure baseline where all jobs start with minimal permissions.

### Job-Specific Permissions

Each job declares only the permissions it needs:

#### 1. Build and Test Job

```yaml
permissions:
  contents: read        # Read repository contents
  pull-requests: write  # Write test results to PR comments
  checks: write         # Write check results
```

**Why these permissions?**
- `contents: read` - Required to checkout code
- `pull-requests: write` - Allows the `publish-unit-test-result-action` to post test results as PR comments
- `checks: write` - Allows writing test check results to the PR

#### 2. Security Scan Job

```yaml
permissions:
  contents: read         # Read repository contents
  security-events: write # Write security scanning results
```

**Why these permissions?**
- `contents: read` - Required to checkout code
- `security-events: write` - Allows uploading security scan results (SARIF format) to GitHub Security tab

#### 3. Deploy Job

```yaml
permissions:
  contents: read   # Read repository contents for checkout and publishing
  id-token: none   # Explicitly disable OIDC token
```

**Why these permissions?**
- `contents: read` - Required to checkout code and build the application
- `id-token: none` - Explicitly disabled because we use Azure publish profile (credential-based), not OIDC federation

## Security Best Practices

### 1. Principle of Least Privilege

Each job has only the minimum permissions required to function. This limits the potential damage if:
- A workflow is compromised
- A malicious actor gains access to the workflow
- A third-party action behaves unexpectedly

### 2. Explicit Permission Declarations

By explicitly declaring permissions at both workflow and job levels:
- We make security requirements transparent
- We prevent accidental permission escalation
- We make it easier to audit and review permissions

### 3. Secure Deployment Method

The deployment uses **Azure Web App publish profile** instead of OIDC federation:
- **Pros**: Simpler setup, direct credential management
- **Cons**: Credentials stored as GitHub secrets (encrypted at rest)
- **Security**: Secrets are never exposed in logs or outputs

### 4. Branch Protection

Deployments are restricted to specific branches:
```yaml
if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop'
```

This ensures only authorized branches can trigger deployments.

## Permission Reference

GitHub Actions supports the following permissions:

| Permission | Description | Used In |
|------------|-------------|---------|
| `contents` | Repository contents (code, commits, releases) | All jobs |
| `pull-requests` | Pull request comments and reviews | Build & Test |
| `checks` | Check runs and check suites | Build & Test |
| `security-events` | Security alerts and code scanning | Security Scan |
| `id-token` | OIDC token for cloud authentication | Not used (explicit none) |

## Migration to OIDC (Future Enhancement)

For enhanced security, consider migrating from publish profile to OIDC federation:

**Benefits:**
- No long-lived credentials
- Automatic token rotation
- Fine-grained access control via Azure Entra ID
- Better audit trails

**Required Changes:**
1. Set up Azure AD App registration
2. Configure federated credentials
3. Update workflow to use `azure/login@v1` with OIDC
4. Update permissions: `id-token: write`

**Example OIDC configuration:**
```yaml
permissions:
  contents: read
  id-token: write  # Required for OIDC

steps:
  - uses: azure/login@v1
    with:
      client-id: ${{ secrets.AZURE_CLIENT_ID }}
      tenant-id: ${{ secrets.AZURE_TENANT_ID }}
      subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  
  - uses: azure/webapps-deploy@v2
    with:
      app-name: ${{ secrets.AZURE_WEBAPP_NAME }}
      package: ./publish
```

## Secrets Management

The workflow uses the following secrets:
- `AZURE_WEBAPP_NAME` - Azure Web App name
- `AZURE_WEBAPP_PUBLISH_PROFILE` - Azure deployment credentials

**Secret Security:**
- Stored encrypted in GitHub
- Never exposed in logs
- Access restricted to workflow runs
- Should be rotated periodically

## Monitoring and Auditing

### Recommended Practices

1. **Review workflow runs regularly** - Check for unexpected behavior
2. **Monitor deployment logs** - Verify successful deployments
3. **Audit secret access** - GitHub provides secret access logs
4. **Update dependencies** - Keep actions and tools up to date
5. **Review permissions quarterly** - Ensure they remain appropriate

### Security Alerts

Enable GitHub security features:
- **Dependabot alerts** - Automated dependency vulnerability scanning
- **Code scanning** - Automated code security analysis
- **Secret scanning** - Detect committed secrets

## Troubleshooting

### Permission Denied Errors

If you encounter permission errors:

1. Check job-level permissions match required operations
2. Verify workflow-level permissions don't restrict job permissions
3. Ensure repository settings allow the required permissions
4. Check if organization policies restrict permissions

### Deployment Failures

If deployment fails:

1. Verify Azure publish profile is valid and not expired
2. Check Azure Web App is running and accessible
3. Verify secrets are correctly configured
4. Review deployment logs for specific errors

## References

- [GitHub Actions Permissions](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token)
- [Security Hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [Azure Web Apps Deploy Action](https://github.com/Azure/webapps-deploy)
- [OIDC with Azure](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)

## Contact

For questions about CI/CD security, contact the repository maintainers or open an issue.

---

**Last Updated:** 2025-11-12  
**Version:** 1.0
