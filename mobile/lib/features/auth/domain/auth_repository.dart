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
}
