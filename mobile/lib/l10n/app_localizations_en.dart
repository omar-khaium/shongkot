// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shongkot Emergency';

  @override
  String get emergencyResponder => 'Emergency Responder';

  @override
  String get tagline => 'One button to connect with nearby responders';

  @override
  String get sosButton => 'Emergency SOS';

  @override
  String get home => 'Home';

  @override
  String get contacts => 'Contacts';

  @override
  String get responders => 'Responders';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get language => 'Language';

  @override
  String get profile => 'Profile';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get addContact => 'Add Contact';

  @override
  String get nearbyResponders => 'Nearby Responders';

  @override
  String get location => 'Location';

  @override
  String get enableLocation => 'Enable Location Services';

  @override
  String get locationRequired =>
      'Location access is required to find nearby responders';

  @override
  String get pressForEmergency => 'Press for Emergency';

  @override
  String get holdToActivate => 'Hold to Activate';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get name => 'Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get email => 'Email';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get sos => 'SOS';

  @override
  String get appearance => 'Appearance';

  @override
  String get emergencySettings => 'Emergency Settings';

  @override
  String get contactsWillBeNotified =>
      'These contacts will be notified during an emergency';

  @override
  String get primaryLabel => 'PRIMARY';

  @override
  String get available => 'AVAILABLE';

  @override
  String get busy => 'BUSY';

  @override
  String get contact => 'Contact';

  @override
  String get active => 'Active';

  @override
  String respondersNearbyCount(int count) {
    return '$count responders nearby';
  }

  @override
  String get profilePlaceholderName => 'User Name';

  @override
  String get profilePlaceholderEmail => 'user@example.com';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get crimeInProgress => 'Crime in Progress';

  @override
  String get rapidCrimeTitle => 'What type of emergency?';

  @override
  String get rapidCrimeSubtitle => 'This helps responders prepare (optional)';

  @override
  String get sexualAssault => 'Sexual Assault / Rape';

  @override
  String get physicalAssault => 'Physical Assault / Beating';

  @override
  String get kidnapping => 'Kidnapping / Abduction';

  @override
  String get otherViolentCrime => 'Other Violent Crime';

  @override
  String get skipThisStep => 'Skip this step';

  @override
  String get rapidSosSent => 'Rapid Emergency Alert Sent';

  @override
  String get rapidSosDescription =>
      'Your location and alert have been recorded. Help is on the way.';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String verificationCodeSentTo(String identifier) {
    return 'We sent a verification code to\n$identifier';
  }

  @override
  String get verify => 'Verify';

  @override
  String get verifying => 'Verifying...';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendInSeconds(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String codeExpiresAt(String time) {
    return 'Code expires at $time';
  }

  @override
  String get enterAllDigits => 'Please enter all 6 digits';

  @override
  String get verifyAccount => 'Verify Account';
}
