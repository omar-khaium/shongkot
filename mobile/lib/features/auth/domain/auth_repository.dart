import 'user.dart';
import 'login_credentials.dart';
import 'auth_models.dart';

/// Contract for all authentication-related data operations.
abstract class AuthRepository {
  /// Register a new user with email or phone.
  Future<RegisterResponse> register(RegisterRequest request);

  /// Determine whether the provided email or phone already has an account.
  Future<bool> isAccountExists(String emailOrPhone);

  /// Attempt to login with the supplied credentials.
  Future<User> login(LoginCredentials credentials);

  /// Refresh the authentication token.
  Future<User> refreshToken(String refreshToken);

  /// Logout and clear any persisted session information.
  Future<void> logout();

  /// Retrieve the currently saved user, if any.
  Future<User?> getCurrentUser();

  /// Persist the current user details to secure storage.
  Future<void> saveUser(User user);

  /// Determine whether saved credentials exist for biometric login.
  Future<bool> hasSavedCredentials();

  /// Read the saved credentials if biometric login is enabled.
  Future<LoginCredentials?> getSavedCredentials();

  /// Persist credentials for biometric login.
  Future<void> saveCredentials(LoginCredentials credentials);

  /// Clear any stored credentials.
  Future<void> clearCredentials();
}
