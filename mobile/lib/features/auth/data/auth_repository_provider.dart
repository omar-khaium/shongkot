import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_repository.dart';
import 'fake_auth_repository.dart';
import 'secure_storage_service.dart';
import 'biometric_service.dart';

/// Provides a single instance of [SecureStorageService] for dependency injection.
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Provides a single instance of [BiometricService] so features can check biometrics.
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

/// Provides the fake auth repository used for development builds.
final fakeAuthRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return FakeAuthRepository(secureStorage: secureStorage);
});

/// Provides the [AuthRepository] implementation used across the app.
/// Hooked through a separate provider so we can easily override it with a real
/// repository once the backend is available (or with mocks in tests).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ref.watch(fakeAuthRepositoryProvider);
});
