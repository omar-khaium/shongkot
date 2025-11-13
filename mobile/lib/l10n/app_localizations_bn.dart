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
}
