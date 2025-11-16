import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'verification_api_service.dart';

final verificationApiServiceProvider = Provider<VerificationApiService>((ref) {
  return VerificationApiService();
});
