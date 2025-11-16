import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/login_credentials.dart';
import '../data/auth_repository_provider.dart';
import '../data/biometric_service.dart';
import 'auth_state.dart';

/// Notifier for managing authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    final authRepository = _ref.read(authRepositoryProvider);
    final user = await authRepository.getCurrentUser();
    
    if (user != null) {
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
      );
    }
  }

  /// Login with email/phone and password
  Future<void> login(LoginCredentials credentials) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      final user = await authRepository.login(credentials);

      // Save credentials for biometric login if remember me is checked
      if (credentials.rememberMe) {
        await authRepository.saveCredentials(credentials);
      }

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  /// Login with biometric authentication
  Future<void> loginWithBiometric({
    required String localizedReason,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      final biometricService = _ref.read(biometricServiceServiceProvider);

      // Check if credentials are saved
      final hasSavedCredentials = await authRepository.hasSavedCredentials();
      if (!hasSavedCredentials) {
        throw Exception('No saved credentials found. Please login with password first.');
      }

      // Authenticate with biometric
      final authenticated = await biometricService.authenticate(
        localizedReason: localizedReason,
      );

      if (!authenticated) {
        throw Exception('Biometric authentication failed');
      }

      // Get saved credentials and login
      final credentials = await authRepository.getSavedCredentials();
      if (credentials == null) {
        throw Exception('Failed to retrieve saved credentials');
      }

      final user = await authRepository.login(credentials);

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    final biometricService = _ref.read(biometricServiceServiceProvider);
    return await biometricService.isBiometricAvailable();
  }

  /// Check if user has saved credentials for biometric login
  Future<bool> hasSavedCredentials() async {
    final authRepository = _ref.read(authRepositoryProvider);
    return await authRepository.hasSavedCredentials();
  }

  /// Logout
  Future<void> logout() async {
    final authRepository = _ref.read(authRepositoryProvider);
    await authRepository.logout();
    
    state = const AuthState();
  }

  /// Clear error
  void clearError() {
    state = state.clearError();
  }
}

/// Provider for BiometricService (fix naming)
final biometricServiceServiceProvider = Provider<BiometricService>((ref) {
  return ref.read(biometricServiceProvider);
});

/// Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
