import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/app_navigation.dart';
import '../../features/auth/presentation/auth_state_provider.dart';
import '../../features/auth/presentation/register_screen.dart';

/// Widget that determines whether to show auth screens or main app
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        // If user is not logged in, show registration screen
        if (user == null) {
          return const RegisterScreen();
        }
        // If user is logged in, show main app
        return const AppNavigation();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // On error, show registration screen as fallback
        return const RegisterScreen();
      },
    );
  }
}
