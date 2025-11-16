/// Login credentials for authentication
class LoginCredentials {
  final String emailOrPhone;
  final String password;
  final bool rememberMe;

  const LoginCredentials({
    required this.emailOrPhone,
    required this.password,
    this.rememberMe = false,
  });

  /// Convert to JSON for API call
  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone': emailOrPhone,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}
