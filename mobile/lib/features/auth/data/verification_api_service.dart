import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/verification_request.dart';
import '../domain/verification_response.dart';

class VerificationApiService {
  final String baseUrl;
  final http.Client client;

  VerificationApiService({
    http.Client? client,
    String? baseUrl,
  })  : client = client ?? http.Client(),
        baseUrl = baseUrl ?? const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:5000/api',
        );

  Future<VerificationResponse> sendCode(VerificationRequest request) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return VerificationResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 429) {
        return VerificationResponse(
          success: false,
          message: 'Please wait before requesting a new code',
        );
      } else {
        return VerificationResponse(
          success: false,
          message: 'Failed to send verification code',
        );
      }
    } catch (e) {
      return VerificationResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<VerificationResponse> verifyCode(String identifier, String code) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        return VerificationResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        String message = 'Verification failed';
        try {
          final error = jsonDecode(response.body);
          if (error is Map<String, dynamic> && error['message'] is String) {
            message = error['message'];
          } else if (response.body.isNotEmpty) {
            message = response.body;
          }
        } catch (_) {
          if (response.body.isNotEmpty) {
            message = response.body;
          }
        }
        return VerificationResponse(
          success: false,
          message: message,
        );
      }
    } catch (e) {
      return VerificationResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<VerificationResponse> resendCode(VerificationRequest request) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/resend-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return VerificationResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 429) {
        return VerificationResponse(
          success: false,
          message: 'Please wait before requesting a new code',
        );
      } else {
        return VerificationResponse(
          success: false,
          message: 'Failed to resend verification code',
        );
      }
    } catch (e) {
      return VerificationResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
