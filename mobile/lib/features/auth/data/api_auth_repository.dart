import '../domain/auth_repository.dart';
import '../domain/user.dart';
import '../domain/login_credentials.dart';
import '../domain/auth_models.dart';
import 'auth_api_client.dart';
import 'secure_storage_service.dart';

/// Real implementation of AuthRepository using API
class ApiAuthRepository implements AuthRepository {
  final AuthApiClient _apiClient;
  final SecureStorageService _secureStorage;

  ApiAuthRepository({
    required AuthApiClient apiClient,
    SecureStorageService? secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage ?? SecureStorageService();

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.register(
        email: request.emailOrPhone.contains('@') ? request.emailOrPhone : null,
        phoneNumber:
            !request.emailOrPhone.contains('@') ? request.emailOrPhone : null,
        password: request.password,
        name: request.name,
        acceptedTerms: request.acceptedTerms,
      );

      // Save user after successful registration
      final user = response.toUser();
      await saveUser(user);

      return RegisterResponse(
        userId: response.userId,
        email: response.email,
        phoneNumber: response.phoneNumber,
        message: 'Registration successful',
      );
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: 'api-error');
    }
  }

  @override
  Future<bool> isAccountExists(String emailOrPhone) async {
    // This would need to be implemented in the API
    // For now, we'll return false
    return false;
  }

  @override
  Future<User> login(LoginCredentials credentials) async {
    try {
      final response = await _apiClient.login(
        emailOrPhone: credentials.emailOrPhone,
        password: credentials.password,
      );

      final user = response.toUser();

      // Save user if remember me is checked
      if (credentials.rememberMe) {
        await saveUser(user);
        await saveCredentials(credentials);
      }

      return user;
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: 'api-error');
    }
  }

  @override
  Future<User> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.refreshToken(refreshToken);

      // Get current user and update tokens
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        throw const AuthException('No current user', code: 'no-user');
      }

      final updatedUser = currentUser.copyWith(
        token: response.accessToken,
        refreshToken: response.refreshToken,
      );

      await saveUser(updatedUser);

      return updatedUser;
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: 'api-error');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final user = await getCurrentUser();
      if (user != null) {
        await _apiClient.logout(user.token);
      }
    } catch (e) {
      // Ignore logout errors, clear local data anyway
    }

    await _secureStorage.deleteUser();
    await clearCredentials();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userData = await _secureStorage.getUser();
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  @override
  Future<void> saveUser(User user) async {
    await _secureStorage.saveUser(user.toJson());
  }

  @override
  Future<bool> hasSavedCredentials() async {
    return await _secureStorage.hasCredentials();
  }

  @override
  Future<LoginCredentials?> getSavedCredentials() async {
    final credentialsData = await _secureStorage.getCredentials();
    if (credentialsData == null) return null;

    return LoginCredentials(
      emailOrPhone: credentialsData['emailOrPhone'] as String,
      password: credentialsData['password'] as String,
      rememberMe: credentialsData['rememberMe'] as bool? ?? false,
    );
  }

  @override
  Future<void> saveCredentials(LoginCredentials credentials) async {
    await _secureStorage.saveCredentials({
      'emailOrPhone': credentials.emailOrPhone,
      'password': credentials.password,
      'rememberMe': credentials.rememberMe,
    });
  }

  @override
  Future<void> clearCredentials() async {
    await _secureStorage.deleteCredentials();
  }

  /// Change password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final user = await getCurrentUser();
      if (user == null) {
        throw const AuthException('No current user', code: 'no-user');
      }

      await _apiClient.changePassword(
        accessToken: user.token,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      // Clear all saved data after password change
      await logout();
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: 'api-error');
    }
  }

  /// Login with Google
  Future<User> loginWithGoogle(String googleToken) async {
    try {
      final response = await _apiClient.loginWithGoogle(googleToken);
      final user = response.toUser();
      await saveUser(user);
      return user;
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: 'api-error');
    }
  }

  /// Login with Facebook
  Future<User> loginWithFacebook(String facebookToken) async {
    try {
      final response = await _apiClient.loginWithFacebook(facebookToken);
      final user = response.toUser();
      await saveUser(user);
      return user;
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: 'api-error');
    }
  }

  /// Login with Apple
  Future<User> loginWithApple(String appleToken) async {
    try {
      final response = await _apiClient.loginWithApple(appleToken);
      final user = response.toUser();
      await saveUser(user);
      return user;
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: 'api-error');
    }
  }
}
