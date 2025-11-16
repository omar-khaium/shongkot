import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/verification_api_service_provider.dart';
import '../domain/verification_request.dart';
import '../domain/verification_response.dart';

class VerificationState {
  final bool isLoading;
  final String? error;
  final bool isVerified;
  final DateTime? expiresAt;
  final DateTime? lastResendTime;

  VerificationState({
    this.isLoading = false,
    this.error,
    this.isVerified = false,
    this.expiresAt,
    this.lastResendTime,
  });

  VerificationState copyWith({
    bool? isLoading,
    String? error,
    bool? isVerified,
    DateTime? expiresAt,
    DateTime? lastResendTime,
  }) {
    return VerificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isVerified: isVerified ?? this.isVerified,
      expiresAt: expiresAt ?? this.expiresAt,
      lastResendTime: lastResendTime ?? this.lastResendTime,
    );
  }

  bool get canResend {
    if (lastResendTime == null) return true;
    final timeSinceLastResend = DateTime.now().difference(lastResendTime!);
    return timeSinceLastResend.inSeconds >= 60;
  }

  int get secondsUntilCanResend {
    if (lastResendTime == null) return 0;
    final timeSinceLastResend = DateTime.now().difference(lastResendTime!);
    final remaining = 60 - timeSinceLastResend.inSeconds;
    return remaining > 0 ? remaining : 0;
  }
}

class VerificationNotifier extends StateNotifier<VerificationState> {
  final Ref ref;
  String? _currentIdentifier;

  VerificationNotifier(this.ref) : super(VerificationState());

  Future<void> sendCode(VerificationRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    _currentIdentifier = request.identifier;

    try {
      final apiService = ref.read(verificationApiServiceProvider);
      final response = await apiService.sendCode(request);

      if (response.success) {
        state = state.copyWith(
          isLoading: false,
          expiresAt: response.expiresAt,
          lastResendTime: DateTime.now(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> verifyCode(String code) async {
    if (_currentIdentifier == null) {
      state = state.copyWith(error: 'No identifier set');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final apiService = ref.read(verificationApiServiceProvider);
      final response = await apiService.verifyCode(_currentIdentifier!, code);

      if (response.success) {
        state = state.copyWith(
          isLoading: false,
          isVerified: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> resendCode(VerificationRequest request) async {
    if (!state.canResend) {
      state = state.copyWith(
        error: 'Please wait ${state.secondsUntilCanResend} seconds before resending',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    _currentIdentifier = request.identifier;

    try {
      final apiService = ref.read(verificationApiServiceProvider);
      final response = await apiService.resendCode(request);

      if (response.success) {
        state = state.copyWith(
          isLoading: false,
          expiresAt: response.expiresAt,
          lastResendTime: DateTime.now(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final verificationProvider = StateNotifierProvider<VerificationNotifier, VerificationState>((ref) {
  return VerificationNotifier(ref);
});
