import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/verification_request.dart';
import '../domain/verification_response.dart';

class VerificationApiService {
  // TODO: Replace with actual API URL from environment config
  static const String baseUrl = 'http://localhost:5000/api';
  
  final http.Client client;

  VerificationApiService({http.Client? client}) : client = client ?? http.Client();

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
        final error = jsonDecode(response.body);
        return VerificationResponse(
          success: false,
          message: error['message'] ?? 'Verification failed',
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
