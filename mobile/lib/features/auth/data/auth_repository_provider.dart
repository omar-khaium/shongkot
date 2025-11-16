import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_repository.dart';
import 'fake_auth_repository.dart';

/// Provider for the auth repository
/// Currently using fake implementation for development
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});
