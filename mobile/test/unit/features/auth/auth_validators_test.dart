import 'package:flutter_test/flutter_test.dart';
import 'package:shongkot_app/features/auth/domain/auth_validators.dart';

void main() {
  group('AuthValidators', () {
    group('Email validation', () {
      test('validates correct email formats', () {
        expect(AuthValidators.isValidEmail('test@example.com'), isTrue);
        expect(AuthValidators.isValidEmail('user.name@domain.co.uk'), isTrue);
        expect(AuthValidators.isValidEmail('user+tag@example.com'), isTrue);
      });

      test('rejects invalid email formats', () {
        expect(AuthValidators.isValidEmail('invalid'), isFalse);
        expect(AuthValidators.isValidEmail('invalid@'), isFalse);
        expect(AuthValidators.isValidEmail('@example.com'), isFalse);
        expect(AuthValidators.isValidEmail('user@'), isFalse);
        expect(AuthValidators.isValidEmail('user@domain'), isFalse);
      });
    });

    group('Phone validation', () {
      test('validates correct phone formats', () {
        expect(AuthValidators.isValidPhone('01712345678'), isTrue);
        expect(AuthValidators.isValidPhone('01812345678'), isTrue);
        expect(AuthValidators.isValidPhone('01912345678'), isTrue);
        expect(AuthValidators.isValidPhone('+8801712345678'), isTrue);
        expect(AuthValidators.isValidPhone('8801712345678'), isTrue);
      });

      test('rejects invalid phone formats', () {
        expect(AuthValidators.isValidPhone('012345678'), isFalse);
        expect(AuthValidators.isValidPhone('0171234567'), isFalse);
        expect(AuthValidators.isValidPhone('02112345678'), isFalse);
        expect(AuthValidators.isValidPhone('abcdefghijk'), isFalse);
      });
    });

    group('Email or phone validation', () {
      test('returns null for valid email', () {
        final result = AuthValidators.validateEmailOrPhone(
          'test@example.com',
          emailRequiredMsg: 'Email required',
          emailInvalidMsg: 'Email invalid',
          phoneInvalidMsg: 'Phone invalid',
        );
        expect(result, isNull);
      });

      test('returns null for valid phone', () {
        final result = AuthValidators.validateEmailOrPhone(
          '01712345678',
          emailRequiredMsg: 'Email required',
          emailInvalidMsg: 'Email invalid',
          phoneInvalidMsg: 'Phone invalid',
        );
        expect(result, isNull);
      });

      test('returns error for empty value', () {
        final result = AuthValidators.validateEmailOrPhone(
          '',
          emailRequiredMsg: 'Email required',
          emailInvalidMsg: 'Email invalid',
          phoneInvalidMsg: 'Phone invalid',
        );
        expect(result, equals('Email required'));
      });

      test('returns error for invalid email', () {
        final result = AuthValidators.validateEmailOrPhone(
          'invalid@',
          emailRequiredMsg: 'Email required',
          emailInvalidMsg: 'Email invalid',
          phoneInvalidMsg: 'Phone invalid',
        );
        expect(result, equals('Email invalid'));
      });

      test('returns error for invalid phone', () {
        final result = AuthValidators.validateEmailOrPhone(
          '012345678',
          emailRequiredMsg: 'Email required',
          emailInvalidMsg: 'Email invalid',
          phoneInvalidMsg: 'Phone invalid',
        );
        expect(result, equals('Phone invalid'));
      });
    });

    group('Password validation', () {
      test('returns null for valid password', () {
        final result = AuthValidators.validatePassword(
          'Test1234',
          passwordRequiredMsg: 'Password required',
          passwordTooShortMsg: 'Too short',
          passwordNoUppercaseMsg: 'No uppercase',
          passwordNoLowercaseMsg: 'No lowercase',
          passwordNoNumberMsg: 'No number',
        );
        expect(result, isNull);
      });

      test('returns error for empty password', () {
        final result = AuthValidators.validatePassword(
          '',
          passwordRequiredMsg: 'Password required',
          passwordTooShortMsg: 'Too short',
          passwordNoUppercaseMsg: 'No uppercase',
          passwordNoLowercaseMsg: 'No lowercase',
          passwordNoNumberMsg: 'No number',
        );
        expect(result, equals('Password required'));
      });

      test('returns error for too short password', () {
        final result = AuthValidators.validatePassword(
          'Test12',
          passwordRequiredMsg: 'Password required',
          passwordTooShortMsg: 'Too short',
          passwordNoUppercaseMsg: 'No uppercase',
          passwordNoLowercaseMsg: 'No lowercase',
          passwordNoNumberMsg: 'No number',
        );
        expect(result, equals('Too short'));
      });

      test('returns error for password without uppercase', () {
        final result = AuthValidators.validatePassword(
          'test1234',
          passwordRequiredMsg: 'Password required',
          passwordTooShortMsg: 'Too short',
          passwordNoUppercaseMsg: 'No uppercase',
          passwordNoLowercaseMsg: 'No lowercase',
          passwordNoNumberMsg: 'No number',
        );
        expect(result, equals('No uppercase'));
      });

      test('returns error for password without lowercase', () {
        final result = AuthValidators.validatePassword(
          'TEST1234',
          passwordRequiredMsg: 'Password required',
          passwordTooShortMsg: 'Too short',
          passwordNoUppercaseMsg: 'No uppercase',
          passwordNoLowercaseMsg: 'No lowercase',
          passwordNoNumberMsg: 'No number',
        );
        expect(result, equals('No lowercase'));
      });

      test('returns error for password without number', () {
        final result = AuthValidators.validatePassword(
          'TestTest',
          passwordRequiredMsg: 'Password required',
          passwordTooShortMsg: 'Too short',
          passwordNoUppercaseMsg: 'No uppercase',
          passwordNoLowercaseMsg: 'No lowercase',
          passwordNoNumberMsg: 'No number',
        );
        expect(result, equals('No number'));
      });
    });

    group('Password confirmation validation', () {
      test('returns null when passwords match', () {
        final result = AuthValidators.validatePasswordConfirmation(
          'Test1234',
          'Test1234',
          passwordRequiredMsg: 'Password required',
          passwordsDoNotMatchMsg: 'Passwords do not match',
        );
        expect(result, isNull);
      });

      test('returns error when passwords do not match', () {
        final result = AuthValidators.validatePasswordConfirmation(
          'Test1234',
          'Test5678',
          passwordRequiredMsg: 'Password required',
          passwordsDoNotMatchMsg: 'Passwords do not match',
        );
        expect(result, equals('Passwords do not match'));
      });

      test('returns error for empty confirmation', () {
        final result = AuthValidators.validatePasswordConfirmation(
          '',
          'Test1234',
          passwordRequiredMsg: 'Password required',
          passwordsDoNotMatchMsg: 'Passwords do not match',
        );
        expect(result, equals('Password required'));
      });
    });

    group('Terms acceptance validation', () {
      test('returns null when terms are accepted', () {
        final result = AuthValidators.validateTermsAcceptance(
          true,
          termsRequiredMsg: 'Terms required',
        );
        expect(result, isNull);
      });

      test('returns error when terms are not accepted', () {
        final result = AuthValidators.validateTermsAcceptance(
          false,
          termsRequiredMsg: 'Terms required',
        );
        expect(result, equals('Terms required'));
      });

      test('returns error when terms value is null', () {
        final result = AuthValidators.validateTermsAcceptance(
          null,
          termsRequiredMsg: 'Terms required',
        );
        expect(result, equals('Terms required'));
      });
    });
  });
}
