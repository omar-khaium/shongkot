import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user.dart';
import '../data/auth_repository_provider.dart';

/// Provider for current user authentication state
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getCurrentUser();
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});
