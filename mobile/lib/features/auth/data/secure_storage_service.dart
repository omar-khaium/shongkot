import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

/// Service for securely storing and retrieving sensitive data
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _userKey = 'user';
  static const String _credentialsKey = 'credentials';

  /// Save user data securely
  Future<void> saveUser(Map<String, dynamic> user) async {
    final userJson = jsonEncode(user);
    await _storage.write(key: _userKey, value: userJson);
  }

  /// Get saved user data
  Future<Map<String, dynamic>?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null;
    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  /// Delete user data
  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }

  /// Save credentials for biometric login
  Future<void> saveCredentials(Map<String, dynamic> credentials) async {
    final credentialsJson = jsonEncode(credentials);
    await _storage.write(key: _credentialsKey, value: credentialsJson);
  }

  /// Get saved credentials
  Future<Map<String, dynamic>?> getCredentials() async {
    final credentialsJson = await _storage.read(key: _credentialsKey);
    if (credentialsJson == null) return null;
    return jsonDecode(credentialsJson) as Map<String, dynamic>;
  }

  /// Delete saved credentials
  Future<void> deleteCredentials() async {
    await _storage.delete(key: _credentialsKey);
  }

  /// Check if credentials are saved
  Future<bool> hasCredentials() async {
    return await _storage.containsKey(key: _credentialsKey);
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
