import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/user.dart';

/// API client for authentication endpoints
class AuthApiClient {
  final String baseUrl;
  final http.Client _client;

  AuthApiClient({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Register a new user
  Future<AuthResponse> register({
    String? email,
    String? phoneNumber,
    required String password,
    String? name,
    required bool acceptedTerms,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'name': name,
        'acceptedTerms': acceptedTerms,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw AuthApiException(error['message'] ?? 'Registration failed');
    }
  }

  /// Login with email/phone and password
  Future<AuthResponse> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'emailOrPhone': emailOrPhone,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw AuthApiException('Invalid email/phone or password');
    } else {
      final error = jsonDecode(response.body);
      throw AuthApiException(error['message'] ?? 'Login failed');
    }
  }

  /// Refresh access token
  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      return RefreshTokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw AuthApiException('Token refresh failed');
    }
  }

  /// Logout
  Future<void> logout(String accessToken) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw AuthApiException('Logout failed');
    }
  }

  /// Change password
  Future<void> changePassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw AuthApiException(error['message'] ?? 'Password change failed');
    }
  }

  /// Login with Google
  Future<AuthResponse> loginWithGoogle(String googleToken) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': googleToken,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw AuthApiException('Google login failed');
    }
  }

  /// Login with Facebook
  Future<AuthResponse> loginWithFacebook(String facebookToken) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/facebook'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': facebookToken,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw AuthApiException('Facebook login failed');
    }
  }

  /// Login with Apple
  Future<AuthResponse> loginWithApple(String appleToken) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/apple'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': appleToken,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw AuthApiException('Apple login failed');
    }
  }
}

/// Response from authentication endpoints
class AuthResponse {
  final String userId;
  final String? email;
  final String? phoneNumber;
  final String? name;
  final String? photoUrl;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  AuthResponse({
    required this.userId,
    this.email,
    this.phoneNumber,
    this.name,
    this.photoUrl,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.tokenType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      tokenType: json['tokenType'] as String? ?? 'Bearer',
    );
  }

  /// Convert to User model
  User toUser() {
    return User(
      id: userId,
      email: email ?? '',
      phone: phoneNumber,
      name: name ?? '',
      photoUrl: photoUrl,
      token: accessToken,
      refreshToken: refreshToken,
    );
  }
}

/// Response from refresh token endpoint
class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.tokenType,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      tokenType: json['tokenType'] as String? ?? 'Bearer',
    );
  }
}

/// Exception thrown by AuthApiClient
class AuthApiException implements Exception {
  final String message;

  AuthApiException(this.message);

  @override
  String toString() => message;
}
