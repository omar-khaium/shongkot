import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_repository.dart';
import 'fake_auth_repository.dart';
import 'secure_storage_service.dart';
import 'biometric_service.dart';

/// Provider for SecureStorageService
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Provider for BiometricService
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

/// Provider for AuthRepository
/// Currently using fake implementation for development
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return FakeAuthRepository(secureStorage: secureStorage);

/// Singleton instance of the auth repository to maintain state across the app
final _authRepositoryInstance = FakeAuthRepository();

/// Provider for the auth repository
/// Currently using fake implementation for development
/// Uses singleton pattern to ensure user data persists across widget rebuilds
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return _authRepositoryInstance;
});
