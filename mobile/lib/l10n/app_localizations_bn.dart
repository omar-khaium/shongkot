// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'সংকট জরুরী';

  @override
  String get emergencyResponder => 'জরুরী সেবা';

  @override
  String get tagline => 'এক বাটনে কাছের সাহায্যকারীদের সাথে যুক্ত হন';

  @override
  String get sosButton => 'জরুরী এসওএস';

  @override
  String get home => 'হোম';

  @override
  String get contacts => 'যোগাযোগ';

  @override
  String get responders => 'সাহায্যকারী';

  @override
  String get settings => 'সেটিংস';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get lightMode => 'লাইট মোড';

  @override
  String get language => 'ভাষা';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get emergencyContacts => 'জরুরী যোগাযোগ';

  @override
  String get addContact => 'যোগাযোগ যোগ করুন';

  @override
  String get nearbyResponders => 'কাছাকাছি সাহায্যকারী';

  @override
  String get location => 'অবস্থান';

  @override
  String get enableLocation => 'লোকেশন সেবা চালু করুন';

  @override
  String get locationRequired => 'কাছের সাহায্যকারীদের খুঁজতে লোকেশন প্রয়োজন';

  @override
  String get pressForEmergency => 'জরুরী অবস্থায় চাপুন';

  @override
  String get holdToActivate => 'সক্রিয় করতে ধরে রাখুন';

  @override
  String get cancel => 'বাতিল';

  @override
  String get confirm => 'নিশ্চিত';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get name => 'নাম';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get email => 'ইমেইল';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get version => 'সংস্করণ';

  @override
  String get theme => 'থিম';

  @override
  String get system => 'সিস্টেম';

  @override
  String get light => 'হালকা';

  @override
  String get dark => 'গাঢ়';

  @override
  String get sos => 'এসওএস';

  @override
  String get appearance => 'চেহারা';

  @override
  String get emergencySettings => 'জরুরী সেটিংস';

  @override
  String get contactsWillBeNotified =>
      'জরুরী অবস্থায় এই পরিচিতিগুলোকে জানানো হবে';

  @override
  String get primaryLabel => 'প্রাথমিক';

  @override
  String get available => 'উপলব্ধ';

  @override
  String get busy => 'ব্যস্ত';

  @override
  String get contact => 'যোগাযোগ';

  @override
  String get active => 'সক্রিয়';

  @override
  String respondersNearbyCount(int count) {
    return '$count জন সাহায্যকারী কাছাকাছি';
  }

  @override
  String get profilePlaceholderName => 'ব্যবহারকারীর নাম';

  @override
  String get profilePlaceholderEmail => 'user@example.com';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get termsOfService => 'সেবার শর্তাবলী';

  @override
  String get crimeInProgress => 'অপরাধ চলছে';

  @override
  String get rapidCrimeTitle => 'কোন ধরনের জরুরী অবস্থা?';

  @override
  String get rapidCrimeSubtitle =>
      'এটি সাহায্যকারীদের প্রস্তুত হতে সাহায্য করে (ঐচ্ছিক)';

  @override
  String get sexualAssault => 'যৌন নিপীড়ন / ধর্ষণ';

  @override
  String get physicalAssault => 'শারীরিক নিপীড়ন / মারধর';

  @override
  String get kidnapping => 'অপহরণ / হরণ';

  @override
  String get otherViolentCrime => 'অন্যান্য সহিংস অপরাধ';

  @override
  String get skipThisStep => 'এই ধাপ এড়িয়ে যান';

  @override
  String get rapidSosSent => 'দ্রুত জরুরী সতর্কতা পাঠানো হয়েছে';

  @override
  String get rapidSosDescription =>
      'আপনার অবস্থান এবং সতর্কতা রেকর্ড করা হয়েছে। সাহায্য আসছে।';

  @override
  String get login => 'লগইন';

  @override
  String get loginTitle => 'স্বাগতম';

  @override
  String get loginSubtitle => 'জরুরী সেবা ব্যবহার করতে সাইন ইন করুন';

  @override
  String get emailOrPhone => 'ইমেইল বা ফোন নম্বর';

  @override
  String get emergencyHistory => 'জরুরী ইতিহাস';

  @override
  String get noEmergencies => 'কোন জরুরী অবস্থা পাওয়া যায়নি';

  @override
  String get noEmergenciesDescription =>
      'আপনার জরুরী ইতিহাস এখানে প্রদর্শিত হবে';

  @override
  String get filterByStatus => 'অবস্থা দ্বারা ফিল্টার করুন';

  @override
  String get allStatuses => 'সকল অবস্থা';

  @override
  String get pending => 'অপেক্ষারত';

  @override
  String get resolved => 'সমাধান করা';

  @override
  String get cancelled => 'বাতিল করা';

  @override
  String get searchEmergencies => 'ধরন বা অবস্থান দ্বারা অনুসন্ধান করুন';

  @override
  String get dateRange => 'তারিখ পরিসীমা';

  @override
  String get from => 'থেকে';

  @override
  String get to => 'পর্যন্ত';

  @override
  String get clearFilters => 'ফিল্টার সাফ করুন';

  @override
  String get sortBy => 'সাজান';

  @override
  String get newest => 'নতুন প্রথম';

  @override
  String get oldest => 'পুরাতন প্রথম';

  @override
  String get loadingEmergencies => 'জরুরী অবস্থা লোড হচ্ছে...';

  @override
  String get noTypeSpecified => 'কোন ধরন নির্দিষ্ট করা হয়নি';

  @override
  String get retry => 'পুনরায় চেষ্টা করুন';

  @override
  String get register => 'নিবন্ধন';

  @override
  String get registerTitle => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get registerSubtitle => 'জরুরী সেবা ব্যবহার করতে সাইন আপ করুন';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get rememberMe => 'আমাকে মনে রাখুন';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get loginWithBiometric => 'বায়োমেট্রিক দিয়ে লগইন';

  @override
  String get biometricReason => 'দ্রুত লগইন করতে প্রমাণীকরণ করুন';

  @override
  String get noBiometricCredentials =>
      'কোন সংরক্ষিত শংসাপত্র নেই। প্রথমে পাসওয়ার্ড দিয়ে লগইন করুন।';

  @override
  String get biometricNotAvailable =>
      'এই ডিভাইসে বায়োমেট্রিক প্রমাণীকরণ উপলব্ধ নেই';

  @override
  String get loginError => 'লগইন ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get invalidCredentials => 'ভুল ইমেইল/ফোন বা পাসওয়ার্ড';

  @override
  String get fieldRequired => 'এই ক্ষেত্রটি আবশ্যক';

  @override
  String get invalidEmail => 'অনুগ্রহ করে একটি বৈধ ইমেইল লিখুন';

  @override
  String get passwordMinLength => 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে?';

  @override
  String get iAgreeToThe => 'আমি সম্মত';

  @override
  String get and => 'এবং';

  @override
  String get registrationSuccess => 'নিবন্ধন সফল!';

  @override
  String get registrationSuccessMessage =>
      'আপনার অ্যাকাউন্ট সফলভাবে তৈরি হয়েছে। অনুগ্রহ করে আপনার যোগাযোগের তথ্য যাচাই করুন।';

  @override
  String get continueToApp => 'অ্যাপে যান';

  @override
  String get verifyAccount => 'অ্যাকাউন্ট যাচাই করুন';

  @override
  String get emailRequired => 'ইমেইল প্রয়োজন';

  @override
  String get emailInvalid => 'অনুগ্রহ করে একটি বৈধ ইমেইল লিখুন';

  @override
  String get phoneRequired => 'ফোন নম্বর প্রয়োজন';

  @override
  String get phoneInvalid => 'অনুগ্রহ করে একটি বৈধ ফোন নম্বর লিখুন';

  @override
  String get passwordRequired => 'পাসওয়ার্ড প্রয়োজন';

  @override
  String get passwordTooShort => 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';

  @override
  String get passwordNoUppercase =>
      'পাসওয়ার্ডে একটি বড় হাতের অক্ষর থাকতে হবে';

  @override
  String get passwordNoLowercase =>
      'পাসওয়ার্ডে একটি ছোট হাতের অক্ষর থাকতে হবে';

  @override
  String get passwordNoNumber => 'পাসওয়ার্ডে একটি সংখ্যা থাকতে হবে';

  @override
  String get passwordsDoNotMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get termsRequired =>
      'আপনাকে শর্তাবলী এবং গোপনীয়তা নীতি স্বীকার করতে হবে';

  @override
  String get accountExists => 'এই ইমেইল/ফোন দিয়ে ইতিমধ্যে একটি অ্যাকাউন্ট আছে';

  @override
  String get registrationFailed =>
      'নিবন্ধন ব্যর্থ। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get networkError =>
      'নেটওয়ার্ক ত্রুটি। অনুগ্রহ করে আপনার সংযোগ পরীক্ষা করুন।';

  @override
  String get pleaseEnterAllSixDigits => 'অনুগ্রহ করে সব ৬টি সংখ্যা লিখুন';
}
