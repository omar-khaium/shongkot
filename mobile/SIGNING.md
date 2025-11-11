# Android Release Signing Configuration

This document explains how to set up Android app signing for release builds.

## Overview

For security reasons, the signing keys (`key.jks` and `key.properties`) are **NOT** stored in the repository. They must be configured separately for local development and in GitHub secrets for CI/CD.

## Local Development Setup

### 1. Generate a Keystore

If you don't have a keystore yet, generate one:

```bash
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias shongkot
```

You'll be prompted for:
- Keystore password
- Key password
- Your name, organization, city, state, country

**Important:** Store these passwords securely! You'll need them for every release.

### 2. Create key.properties

Create a file `mobile/android/key.properties` with:

```properties
storePassword=<your-keystore-password>
keyPassword=<your-key-password>
keyAlias=shongkot
storeFile=../app/key.jks
```

### 3. Place Keystore File

Move the generated `key.jks` file to `mobile/android/app/key.jks`

### 4. Verify .gitignore

Ensure these files are in `.gitignore` (already configured):
- `/android/key.properties`
- `/android/app/key.jks`
- `/android/app/*.jks`

### 5. Build Release APK/AAB

```bash
cd mobile
flutter build apk --release
# or
flutter build appbundle --release
```

## GitHub Actions / CI/CD Setup

For automated builds in GitHub Actions, store the signing keys as secrets.

### 1. Encode Keystore to Base64

```bash
base64 key.jks > key.jks.base64.txt
```

Or on macOS:
```bash
base64 -i key.jks -o key.jks.base64.txt
```

### 2. Add GitHub Secrets

Go to: **Repository Settings → Secrets and variables → Actions → New repository secret**

Add these secrets:

| Secret Name | Description | Value |
|-------------|-------------|-------|
| `KEYSTORE_BASE64` | Base64 encoded keystore file | Contents of `key.jks.base64.txt` |
| `KEYSTORE_PASSWORD` | Keystore password | Your keystore password |
| `KEY_ALIAS` | Key alias | `shongkot` (or your alias) |
| `KEY_PASSWORD` | Key password | Your key password |

### 3. Update GitHub Actions Workflow

The workflow should decode the keystore and create `key.properties`:

```yaml
- name: Setup signing keys
  env:
    KEYSTORE_BASE64: ${{ secrets.KEYSTORE_BASE64 }}
    KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
    KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
    KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
  run: |
    # Decode keystore
    echo "$KEYSTORE_BASE64" | base64 --decode > android/app/key.jks
    
    # Create key.properties
    cat > android/key.properties << EOF
    storePassword=$KEYSTORE_PASSWORD
    keyPassword=$KEY_PASSWORD
    keyAlias=$KEY_ALIAS
    storeFile=../app/key.jks
    EOF
  working-directory: ./mobile

- name: Build APK
  run: flutter build apk --release
  working-directory: ./mobile

- name: Build AAB
  run: flutter build appbundle --release
  working-directory: ./mobile
```

## Build Configuration

The `build.gradle` file is configured to:

1. **Check for key.properties**: If it exists, use release signing
2. **Fallback to debug signing**: If keys are not available (for development)
3. **Enable ProGuard**: Minify and obfuscate code for release builds

### Release Build Features

- ✅ Code minification (reduces APK size)
- ✅ Resource shrinking (removes unused resources)
- ✅ ProGuard obfuscation (protects code)
- ✅ Proper signing with release key

## Security Best Practices

### ✅ DO:
- Store keystore and passwords in secure password manager
- Use strong passwords (16+ characters)
- Keep keystore backup in multiple secure locations
- Rotate keys if compromised
- Use GitHub secrets for CI/CD

### ❌ DON'T:
- Commit keystore or key.properties to git
- Share keystore or passwords in plain text
- Use weak passwords
- Store keys in public locations
- Email or message keys

## Troubleshooting

### Build fails with "Keystore not found"

**Solution:** Ensure `key.jks` exists at `mobile/android/app/key.jks`

### "Wrong password" error

**Solution:** Verify passwords in `key.properties` match your keystore

### Build succeeds but app won't install

**Solution:** Uninstall the debug version first. Release and debug use different signatures.

### CI/CD build fails with signing error

**Solution:** 
1. Verify all GitHub secrets are set correctly
2. Check base64 encoding didn't add line breaks
3. Ensure workflow decodes keystore before building

## File Structure

```
mobile/
├── android/
│   ├── app/
│   │   ├── key.jks              # NOT in git (add to .gitignore)
│   │   ├── build.gradle         # Configured for release signing
│   │   └── proguard-rules.pro   # ProGuard configuration
│   └── key.properties           # NOT in git (add to .gitignore)
```

## Additional Resources

- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Flutter Release Build](https://docs.flutter.dev/deployment/android)
- [ProGuard Configuration](https://developer.android.com/studio/build/shrink-code)
