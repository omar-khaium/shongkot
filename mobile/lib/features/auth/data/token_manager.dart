import 'dart:async';
import '../domain/user.dart';
import 'auth_api_client.dart';
import 'secure_storage_service.dart';

/// Manages token refresh and expiration
class TokenManager {
  final AuthApiClient _apiClient;
  final SecureStorageService _secureStorage;
  Timer? _refreshTimer;

  TokenManager({
    required AuthApiClient apiClient,
    SecureStorageService? secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage ?? SecureStorageService();

  /// Start automatic token refresh
  void startAutoRefresh(User user, DateTime expiresAt) {
    // Cancel any existing timer
    _refreshTimer?.cancel();

    // Calculate when to refresh (2 minutes before expiration)
    final now = DateTime.now();
    final refreshAt = expiresAt.subtract(const Duration(minutes: 2));
    final duration = refreshAt.difference(now);

    if (duration.isNegative) {
      // Token already expired or about to expire, refresh immediately
      _refreshToken(user.refreshToken);
    } else {
      // Schedule refresh
      _refreshTimer = Timer(duration, () {
        _refreshToken(user.refreshToken);
      });
    }
  }

  /// Stop automatic token refresh
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Manually refresh token
  Future<User?> refreshToken(String refreshToken) async {
    return await _refreshToken(refreshToken);
  }

  Future<User?> _refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.refreshToken(refreshToken);

      // Get current user and update tokens
      final userData = await _secureStorage.getUser();
      if (userData == null) return null;

      final currentUser = User.fromJson(userData);
      final updatedUser = currentUser.copyWith(
        token: response.accessToken,
        refreshToken: response.refreshToken,
      );

      // Save updated user
      await _secureStorage.saveUser(updatedUser.toJson());

      // Schedule next refresh
      startAutoRefresh(updatedUser, response.expiresAt);

      return updatedUser;
    } catch (e) {
      // If refresh fails, clear user data and stop auto-refresh
      stopAutoRefresh();
      await _secureStorage.deleteUser();
      return null;
    }
  }

  void dispose() {
    stopAutoRefresh();
  }
}
