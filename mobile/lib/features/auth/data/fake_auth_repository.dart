import '../domain/auth_repository.dart';
import '../domain/user.dart';
import '../domain/login_credentials.dart';
import 'secure_storage_service.dart';

/// Fake implementation of AuthRepository for testing and development
class FakeAuthRepository implements AuthRepository {
  final SecureStorageService _secureStorage;

  FakeAuthRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  // Fake user for testing
  static const _fakeUser = User(
    id: 'user-123',
    email: 'test@example.com',
    phone: '+8801234567890',
    name: 'Test User',
    photoUrl: null,
    token: 'fake-jwt-token',
    refreshToken: 'fake-refresh-token',
  );

  @override
  Future<User> login(LoginCredentials credentials) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation - accept any non-empty credentials for testing
    if (credentials.emailOrPhone.isEmpty || credentials.password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    // For demo purposes, accept specific test credentials
    if (credentials.password == 'wrong') {
      throw Exception('Invalid email/phone or password');
    }

    // Save user if remember me is checked
    if (credentials.rememberMe) {
      await saveUser(_fakeUser);
    }

    return _fakeUser;
  }

  @override
  Future<User> refreshToken(String refreshToken) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (refreshToken != 'fake-refresh-token') {
      throw Exception('Invalid refresh token');
    }

    return _fakeUser;
  }

  @override
  Future<void> logout() async {
    await _secureStorage.deleteUser();
import '../domain/auth_models.dart';
import '../domain/user.dart';

/// Fake implementation of AuthRepository for development and testing
class FakeAuthRepository implements AuthRepository {
  // Simulated database of registered users
  final Map<String, User> _users = {};
  User? _currentUser;

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if account already exists
    final exists = await isAccountExists(request.emailOrPhone);
    if (exists) {
      throw const AuthException(
        'An account with this email/phone already exists',
        code: 'account-exists',
      );
    }

    // Create new user
    final isEmail = request.emailOrPhone.contains('@');
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    
    final user = User(
      id: userId,
      email: isEmail ? request.emailOrPhone : null,
      phoneNumber: !isEmail ? request.emailOrPhone : null,
      createdAt: DateTime.now(),
    );

    _users[request.emailOrPhone] = user;
    _currentUser = user;

    return RegisterResponse(
      userId: userId,
      email: user.email,
      phoneNumber: user.phoneNumber,
      message: 'Registration successful',
    );
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
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Future<bool> isAccountExists(String emailOrPhone) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _users.containsKey(emailOrPhone);
  }

  /// Clear all data (for testing)
  void clear() {
    _users.clear();
    _currentUser = null;
  }
}
