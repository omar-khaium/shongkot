/// Registration request model
class RegisterRequest {
  final String emailOrPhone;
  final String password;
  final bool acceptedTerms;

  const RegisterRequest({
    required this.emailOrPhone,
    required this.password,
    required this.acceptedTerms,
  });

  Map<String, dynamic> toJson() {
    final bool isEmail = emailOrPhone.contains('@');
    return {
      if (isEmail) 'email': emailOrPhone else 'phoneNumber': emailOrPhone,
      'password': password,
      'acceptedTerms': acceptedTerms,
    };
  }
}

/// Registration response model
class RegisterResponse {
  final String userId;
  final String? email;
  final String? phoneNumber;
  final String message;

  const RegisterResponse({
    required this.userId,
    this.email,
    this.phoneNumber,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      userId: json['userId'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      message: json['message'] as String? ?? 'Registration successful',
    );
  }
}

/// Authentication exception
class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() => message;
}
