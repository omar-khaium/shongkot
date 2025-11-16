import 'user.dart';
import 'login_credentials.dart';

/// Abstract repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email/phone and password
  Future<User> login(LoginCredentials credentials);

  /// Refresh authentication token
  Future<User> refreshToken(String refreshToken);

  /// Logout current user
  Future<void> logout();

  /// Get current user from secure storage
  Future<User?> getCurrentUser();

  /// Save user to secure storage
  Future<void> saveUser(User user);

  /// Check if user has saved credentials for biometric login
  Future<bool> hasSavedCredentials();

  /// Get saved credentials for biometric login
  Future<LoginCredentials?> getSavedCredentials();

  /// Save credentials for biometric login
  Future<void> saveCredentials(LoginCredentials credentials);

  /// Clear saved credentials
  Future<void> clearCredentials();
import 'auth_models.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Register a new user with email or phone
  Future<RegisterResponse> register(RegisterRequest request);

  /// Get current user (if any)
  Future<User?> getCurrentUser();

  /// Check if email/phone is already registered
  Future<bool> isAccountExists(String emailOrPhone);
}
