import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';
import '../data/auth_repository_provider.dart';

/// Registration state
class RegisterState {
  final bool isLoading;
  final RegisterResponse? response;
  final String? error;

  const RegisterState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  RegisterState copyWith({
    bool? isLoading,
    RegisterResponse? response,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error,
    );
  }
}

/// Registration notifier
class RegisterNotifier extends StateNotifier<RegisterState> {
  final AuthRepository _authRepository;

  RegisterNotifier(this._authRepository) : super(const RegisterState());

  /// Register a new user
  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authRepository.register(request);
      state = state.copyWith(
        isLoading: false,
        response: response,
        error: null,
      );
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Registration failed. Please try again.',
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for registration notifier
final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterNotifier(authRepository);
});
