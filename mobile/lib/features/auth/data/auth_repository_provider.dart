import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_repository.dart';
import 'fake_auth_repository.dart';

/// Singleton instance of the auth repository to maintain state across the app
final _authRepositoryInstance = FakeAuthRepository();

/// Provider for the auth repository
/// Currently using fake implementation for development
/// Uses singleton pattern to ensure user data persists across widget rebuilds
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return _authRepositoryInstance;
});
