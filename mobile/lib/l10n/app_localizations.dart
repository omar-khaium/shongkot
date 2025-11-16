import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Shongkot Emergency'**
  String get appTitle;

  /// Main heading text
  ///
  /// In en, this message translates to:
  /// **'Emergency Responder'**
  String get emergencyResponder;

  /// App tagline
  ///
  /// In en, this message translates to:
  /// **'One button to connect with nearby responders'**
  String get tagline;

  /// Emergency SOS button label
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get sosButton;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Contacts navigation label
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// Responders navigation label
  ///
  /// In en, this message translates to:
  /// **'Responders'**
  String get responders;

  /// Settings navigation label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Emergency contacts label
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// Add contact button label
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// Nearby responders label
  ///
  /// In en, this message translates to:
  /// **'Nearby Responders'**
  String get nearbyResponders;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Enable location services prompt
  ///
  /// In en, this message translates to:
  /// **'Enable Location Services'**
  String get enableLocation;

  /// Location requirement message
  ///
  /// In en, this message translates to:
  /// **'Location access is required to find nearby responders'**
  String get locationRequired;

  /// Emergency button instruction
  ///
  /// In en, this message translates to:
  /// **'Press for Emergency'**
  String get pressForEmergency;

  /// Hold button instruction
  ///
  /// In en, this message translates to:
  /// **'Hold to Activate'**
  String get holdToActivate;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// About section label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Theme label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Emergency SOS text
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// Appearance section label
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Emergency settings section label
  ///
  /// In en, this message translates to:
  /// **'Emergency Settings'**
  String get emergencySettings;

  /// Emergency contacts description
  ///
  /// In en, this message translates to:
  /// **'These contacts will be notified during an emergency'**
  String get contactsWillBeNotified;

  /// Primary contact badge label
  ///
  /// In en, this message translates to:
  /// **'PRIMARY'**
  String get primaryLabel;

  /// Available status label
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE'**
  String get available;

  /// Busy status label
  ///
  /// In en, this message translates to:
  /// **'BUSY'**
  String get busy;

  /// Contact action button
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Active status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Number of responders nearby
  ///
  /// In en, this message translates to:
  /// **'{count} responders nearby'**
  String respondersNearbyCount(int count);

  /// Placeholder name for profile
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get profilePlaceholderName;

  /// Placeholder email for profile
  ///
  /// In en, this message translates to:
  /// **'user@example.com'**
  String get profilePlaceholderEmail;

  /// Privacy policy label
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of service label
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Crime in progress button label
  ///
  /// In en, this message translates to:
  /// **'Crime in Progress'**
  String get crimeInProgress;

  /// Title for rapid crime SOS type selector
  ///
  /// In en, this message translates to:
  /// **'What type of emergency?'**
  String get rapidCrimeTitle;

  /// Subtitle for rapid crime SOS type selector
  ///
  /// In en, this message translates to:
  /// **'This helps responders prepare (optional)'**
  String get rapidCrimeSubtitle;

  /// Sexual assault emergency type
  ///
  /// In en, this message translates to:
  /// **'Sexual Assault / Rape'**
  String get sexualAssault;

  /// Physical assault emergency type
  ///
  /// In en, this message translates to:
  /// **'Physical Assault / Beating'**
  String get physicalAssault;

  /// Kidnapping emergency type
  ///
  /// In en, this message translates to:
  /// **'Kidnapping / Abduction'**
  String get kidnapping;

  /// Other violent crime emergency type
  ///
  /// In en, this message translates to:
  /// **'Other Violent Crime'**
  String get otherViolentCrime;

  /// Skip button for type selector
  ///
  /// In en, this message translates to:
  /// **'Skip this step'**
  String get skipThisStep;

  /// Confirmation message for rapid SOS
  ///
  /// In en, this message translates to:
  /// **'Rapid Emergency Alert Sent'**
  String get rapidSosSent;

  /// Description for rapid SOS confirmation
  ///
  /// In en, this message translates to:
  /// **'Your location and alert have been recorded. Help is on the way.'**
  String get rapidSosDescription;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to access emergency features'**
  String get loginSubtitle;

  /// Email or phone input label
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get emailOrPhone;

  /// Emergency history screen title
  ///
  /// In en, this message translates to:
  /// **'Emergency History'**
  String get emergencyHistory;

  /// Empty state message when no emergencies exist
  ///
  /// In en, this message translates to:
  /// **'No emergencies found'**
  String get noEmergencies;

  /// Empty state description
  ///
  /// In en, this message translates to:
  /// **'Your emergency history will appear here'**
  String get noEmergenciesDescription;

  /// Filter by status label
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get filterByStatus;

  /// All statuses filter option
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Resolved status
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// Cancelled status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Search field hint
  ///
  /// In en, this message translates to:
  /// **'Search by type or location'**
  String get searchEmergencies;

  /// Date range filter label
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// From date label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// To date label
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Clear filters button
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// Newest first sort option
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newest;

  /// Oldest first sort option
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldest;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading emergencies...'**
  String get loadingEmergencies;

  /// Message when emergency type is not specified
  ///
  /// In en, this message translates to:
  /// **'No Type Specified'**
  String get noTypeSpecified;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Register button label
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Registration screen title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// Registration screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up to access emergency response features'**
  String get registerSubtitle;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Remember me checkbox label
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Biometric login button label
  ///
  /// In en, this message translates to:
  /// **'Login with Biometric'**
  String get loginWithBiometric;

  /// Biometric authentication reason
  ///
  /// In en, this message translates to:
  /// **'Authenticate to login quickly'**
  String get biometricReason;

  /// Message when no credentials are saved for biometric login
  ///
  /// In en, this message translates to:
  /// **'No saved credentials. Please login with password first.'**
  String get noBiometricCredentials;

  /// Message when biometric is not available
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device'**
  String get biometricNotAvailable;

  /// Generic login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginError;

  /// Invalid credentials error
  ///
  /// In en, this message translates to:
  /// **'Invalid email/phone or password'**
  String get invalidCredentials;

  /// Required field validation message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Invalid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Password minimum length validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Prompt for existing users
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Terms acceptance prefix
  ///
  /// In en, this message translates to:
  /// **'I agree to the'**
  String get iAgreeToThe;

  /// Conjunction between terms and privacy
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// Registration success title
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get registrationSuccess;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully. Please verify your contact information.'**
  String get registrationSuccessMessage;

  /// Continue button after registration
  ///
  /// In en, this message translates to:
  /// **'Continue to App'**
  String get continueToApp;

  /// Verify account button
  ///
  /// In en, this message translates to:
  /// **'Verify Account'**
  String get verifyAccount;

  /// Email required error
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Email invalid error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// Phone required error
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// Phone invalid error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneInvalid;

  /// Password required error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password too short error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// Password no uppercase error
  ///
  /// In en, this message translates to:
  /// **'Password must contain an uppercase letter'**
  String get passwordNoUppercase;

  /// Password no lowercase error
  ///
  /// In en, this message translates to:
  /// **'Password must contain a lowercase letter'**
  String get passwordNoLowercase;

  /// Password no number error
  ///
  /// In en, this message translates to:
  /// **'Password must contain a number'**
  String get passwordNoNumber;

  /// Passwords mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Terms acceptance required error
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and privacy policy'**
  String get termsRequired;

  /// Account already exists error
  ///
  /// In en, this message translates to:
  /// **'An account with this email/phone already exists'**
  String get accountExists;

  /// Generic registration failure message
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// Error message when OTP is incomplete
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits'**
  String get pleaseEnterAllSixDigits;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
