import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fake_location_service.dart';
import 'location_service.dart';

/// Provider for the location service
final locationServiceProvider = Provider<LocationService>((ref) {
  return FakeLocationService();
});
