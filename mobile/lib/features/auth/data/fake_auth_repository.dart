import '../domain/auth_repository.dart';
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
