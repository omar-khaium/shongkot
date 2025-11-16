/// Form validators for authentication
class AuthValidators {
  /// Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Phone validation regex pattern (supports various formats)
  /// Supports: +8801XXXXXXXXX, 8801XXXXXXXXX, 01XXXXXXXXX, 1XXXXXXXXX
  static final RegExp _phoneRegex = RegExp(
    r'^(\+?88)?0?1[3-9]\d{8}$',
  );

  /// Validate email format
  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validate phone format
  static bool isValidPhone(String phone) {
    return _phoneRegex.hasMatch(phone.trim());
  }

  /// Validate email or phone
  static String? validateEmailOrPhone(String? value, {
    required String emailRequiredMsg,
    required String emailInvalidMsg,
    required String phoneInvalidMsg,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emailRequiredMsg;
    }

    final trimmed = value.trim();
    final isEmail = trimmed.contains('@');

    if (isEmail) {
      if (!isValidEmail(trimmed)) {
        return emailInvalidMsg;
      }
    } else {
      if (!isValidPhone(trimmed)) {
        return phoneInvalidMsg;
      }
    }

    return null;
  }

  /// Validate password strength
  /// Requirements: min 8 chars, uppercase, lowercase, number
  static String? validatePassword(String? value, {
    required String passwordRequiredMsg,
    required String passwordTooShortMsg,
    required String passwordNoUppercaseMsg,
    required String passwordNoLowercaseMsg,
    required String passwordNoNumberMsg,
  }) {
    if (value == null || value.isEmpty) {
      return passwordRequiredMsg;
    }

    if (value.length < 8) {
      return passwordTooShortMsg;
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return passwordNoUppercaseMsg;
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return passwordNoLowercaseMsg;
    }

    if (!RegExp(r'\d').hasMatch(value)) {
      return passwordNoNumberMsg;
    }

    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirmation(
    String? value,
    String password, {
    required String passwordRequiredMsg,
    required String passwordsDoNotMatchMsg,
  }) {
    if (value == null || value.isEmpty) {
      return passwordRequiredMsg;
    }

    if (value != password) {
      return passwordsDoNotMatchMsg;
    }

    return null;
  }

  /// Validate terms acceptance
  static String? validateTermsAcceptance(
    bool? value, {
    required String termsRequiredMsg,
  }) {
    if (value != true) {
      return termsRequiredMsg;
    }
    return null;
  }
}
