import 'user.dart';
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
