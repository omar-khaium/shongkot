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
});
