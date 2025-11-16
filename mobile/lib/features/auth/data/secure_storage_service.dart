import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing and retrieving sensitive data
class SecureStorageService {
  final FlutterSecureStorage _storage;
  final Map<String, String> _inMemoryStore = {};

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _userKey = 'user';
  static const String _credentialsKey = 'credentials';

  /// Save user data securely
  Future<void> saveUser(Map<String, dynamic> user) async =>
      _write(_userKey, jsonEncode(user));

  /// Get saved user data
  Future<Map<String, dynamic>?> getUser() async {
    final userJson = await _read(_userKey);
    if (userJson == null) return null;
    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  /// Delete user data
  Future<void> deleteUser() async => _delete(_userKey);

  /// Save credentials for biometric login
  Future<void> saveCredentials(Map<String, dynamic> credentials) async =>
      _write(_credentialsKey, jsonEncode(credentials));

  /// Get saved credentials
  Future<Map<String, dynamic>?> getCredentials() async {
    final credentialsJson = await _read(_credentialsKey);
    if (credentialsJson == null) return null;
    return jsonDecode(credentialsJson) as Map<String, dynamic>;
  }

  /// Delete saved credentials
  Future<void> deleteCredentials() async => _delete(_credentialsKey);

  /// Check if credentials are saved
  Future<bool> hasCredentials() async => _containsKey(_credentialsKey);

  /// Clear all secure storage
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } on MissingPluginException {
      _inMemoryStore.clear();
    }
  }

  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on MissingPluginException {
      _inMemoryStore[key] = value;
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on MissingPluginException {
      return _inMemoryStore[key];
    }
  }

  Future<void> _delete(String key) async {
    try {
      await _storage.delete(key: key);
    } on MissingPluginException {
      _inMemoryStore.remove(key);
    }
  }

  Future<bool> _containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } on MissingPluginException {
      return _inMemoryStore.containsKey(key);
    }
  }
}
