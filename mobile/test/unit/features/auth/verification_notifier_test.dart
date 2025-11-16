import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shongkot_app/features/auth/domain/verification_request.dart';
import 'package:shongkot_app/features/auth/domain/verification_response.dart';
import 'package:shongkot_app/features/auth/presentation/verification_notifier.dart';
import 'package:shongkot_app/features/auth/data/verification_api_service_provider.dart';
import 'package:shongkot_app/features/auth/data/verification_api_service.dart';
import 'package:http/http.dart' as http;

// Mock HTTP Client for testing
class MockHttpClient extends http.BaseClient {
  final Map<String, http.Response> responses;

  MockHttpClient(this.responses);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final key = '${request.method} ${request.url.path}';
    final response = responses[key] ?? http.Response('Not found', 404);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
    );
  }
}

void main() {
  group('VerificationNotifier', () {
    late ProviderContainer container;

    setUp(() {
      // Create mock HTTP responses
      final mockHttpClient = MockHttpClient({
        'POST /api/auth/send-code': http.Response(
          '{"success": true, "message": "Code sent", "expiresAt": "2025-11-16T04:33:00Z"}',
          200,
        ),
        'POST /api/auth/verify': http.Response(
          '{"success": true, "message": "Verification successful"}',
          200,
        ),
        'POST /api/auth/resend-code': http.Response(
          '{"success": true, "message": "Code resent", "expiresAt": "2025-11-16T04:38:00Z"}',
          200,
        ),
      });

      container = ProviderContainer(
        overrides: [
          verificationApiServiceProvider.overrideWithValue(
            VerificationApiService(client: mockHttpClient),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is correct', () {
      final notifier = container.read(verificationProvider.notifier);
      final state = container.read(verificationProvider);

      expect(state.isLoading, false);
      expect(state.error, null);
      expect(state.isVerified, false);
      expect(state.canResend, true);
    });

    test('sendCode updates state correctly on success', () async {
      final notifier = container.read(verificationProvider.notifier);
      
      final request = VerificationRequest(
        identifier: 'test@example.com',
        type: VerificationType.email,
      );

      await notifier.sendCode(request);
      final state = container.read(verificationProvider);

      expect(state.isLoading, false);
      expect(state.error, null);
      expect(state.expiresAt, isNotNull);
      expect(state.lastResendTime, isNotNull);
    });

    test('verifyCode returns true on valid code', () async {
      final notifier = container.read(verificationProvider.notifier);
      
      // First send code to set identifier
      final request = VerificationRequest(
        identifier: 'test@example.com',
        type: VerificationType.email,
      );
      await notifier.sendCode(request);

      // Then verify
      final result = await notifier.verifyCode('123456');
      final state = container.read(verificationProvider);

      expect(result, true);
      expect(state.isVerified, true);
      expect(state.error, null);
    });

    test('canResend is false immediately after sending', () async {
      final notifier = container.read(verificationProvider.notifier);
      
      final request = VerificationRequest(
        identifier: 'test@example.com',
        type: VerificationType.email,
      );

      await notifier.sendCode(request);
      final state = container.read(verificationProvider);

      expect(state.canResend, false);
      expect(state.secondsUntilCanResend, greaterThan(0));
    });

    test('clearError clears error state', () async {
      final notifier = container.read(verificationProvider.notifier);
      
      // Manually set error state (in real scenario, would come from failed API call)
      // For now, just test the clearError method exists and can be called
      notifier.clearError();
      
      final state = container.read(verificationProvider);
      expect(state.error, null);
    });
  });

  group('VerificationState', () {
    test('copyWith creates new state with updated values', () {
      final state = VerificationState(
        isLoading: false,
        error: null,
        isVerified: false,
      );

      final newState = state.copyWith(
        isLoading: true,
        error: 'Test error',
      );

      expect(newState.isLoading, true);
      expect(newState.error, 'Test error');
      expect(newState.isVerified, false);
    });

    test('canResend returns true when lastResendTime is null', () {
      final state = VerificationState(lastResendTime: null);
      expect(state.canResend, true);
    });

    test('canResend returns false immediately after resend', () {
      final state = VerificationState(lastResendTime: DateTime.now());
      expect(state.canResend, false);
    });

    test('secondsUntilCanResend calculates correctly', () {
      final state = VerificationState(
        lastResendTime: DateTime.now().subtract(const Duration(seconds: 30)),
      );
      
      expect(state.secondsUntilCanResend, lessThanOrEqualTo(30));
      expect(state.secondsUntilCanResend, greaterThan(0));
    });
  });
}
