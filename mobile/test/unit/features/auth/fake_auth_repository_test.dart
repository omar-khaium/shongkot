import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/features/auth/data/fake_auth_repository.dart';
import 'package:shongkot_app/features/auth/domain/login_credentials.dart';

void main() {
  late FakeAuthRepository repository;

  setUp(() {
    repository = FakeAuthRepository();
  });

  group('FakeAuthRepository', () {
    group('login', () {
      test('should successfully login with valid credentials', () async {
        // Arrange
        const credentials = LoginCredentials(
          emailOrPhone: 'test@example.com',
          password: 'password123',
          rememberMe: false,
        );

        // Act
        final user = await repository.login(credentials);

        // Assert
        expect(user.email, 'test@example.com');
        expect(user.id, 'user-123');
        expect(user.token, isNotEmpty);
      });

      test('should throw exception for empty credentials', () async {
        // Arrange
        const credentials = LoginCredentials(
          emailOrPhone: '',
          password: '',
          rememberMe: false,
        );

        // Act & Assert
        expect(
          () => repository.login(credentials),
          throwsException,
        );
      });

      test('should throw exception for wrong password', () async {
        // Arrange
        const credentials = LoginCredentials(
          emailOrPhone: 'test@example.com',
          password: 'wrong',
          rememberMe: false,
        );

        // Act & Assert
        expect(
          () => repository.login(credentials),
          throwsException,
        );
      });

      test('should save user when rememberMe is true', () async {
        // Arrange
        const credentials = LoginCredentials(
          emailOrPhone: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        );

        // Act
        await repository.login(credentials);
        final savedUser = await repository.getCurrentUser();

        // Assert
        expect(savedUser, isNotNull);
        expect(savedUser!.email, 'test@example.com');
      });
    });

    group('getCurrentUser', () {
      test('should return null when no user is saved', () async {
        // Act
        final user = await repository.getCurrentUser();

        // Assert
        expect(user, isNull);
      });

      test('should return saved user', () async {
        // Arrange
        const credentials = LoginCredentials(
          emailOrPhone: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        );
        await repository.login(credentials);

        // Act
        final user = await repository.getCurrentUser();

        // Assert
        expect(user, isNotNull);
        expect(user!.email, 'test@example.com');
      });
    });

    group('logout', () {
      test('should clear saved user', () async {
        // Arrange
        const credentials = LoginCredentials(
          emailOrPhone: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        );
        await repository.login(credentials);

        // Act
        await repository.logout();
        final user = await repository.getCurrentUser();

        // Assert
        expect(user, isNull);
      });
    });

    group('credentials management', () {
      test('should save and retrieve credentials', () async {
        // Arrange
        const credentials = LoginCredentials(
          emailOrPhone: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        );

        // Act
        await repository.saveCredentials(credentials);
        final hasCreds = await repository.hasSavedCredentials();
        final savedCreds = await repository.getSavedCredentials();

        // Assert
        expect(hasCreds, isTrue);
        expect(savedCreds, isNotNull);
        expect(savedCreds!.emailOrPhone, 'test@example.com');
        expect(savedCreds.password, 'password123');
      });

      test('should return false when no credentials saved', () async {
        // Act
        final hasCreds = await repository.hasSavedCredentials();

        // Assert
        expect(hasCreds, isFalse);
      });

      test('should clear saved credentials', () async {
        // Arrange
        const credentials = LoginCredentials(
          emailOrPhone: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        );
        await repository.saveCredentials(credentials);

        // Act
        await repository.clearCredentials();
        final hasCreds = await repository.hasSavedCredentials();

        // Assert
        expect(hasCreds, isFalse);
      });
    });

    group('refreshToken', () {
      test('should refresh token successfully', () async {
        // Act
        final user = await repository.refreshToken('fake-refresh-token');

        // Assert
        expect(user, isNotNull);
        expect(user.token, isNotEmpty);
      });

      test('should throw exception for invalid refresh token', () async {
        // Act & Assert
        expect(
          () => repository.refreshToken('invalid-token'),
          throwsException,
        );
      });
    });
  });
}
