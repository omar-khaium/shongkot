import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fake_location_service.dart';
import 'location_service.dart';
import 'real_location_service.dart';

/// Configuration for which location service to use
/// Set to false for production (real GPS)
/// Set to true for development/testing (fake location)
const bool _useFakeLocationService = false;

/// Provider for the location service
/// Uses real GPS location service in production
/// Can be switched to fake service for testing
final locationServiceProvider = Provider<LocationService>((ref) {
  if (_useFakeLocationService) {
    return FakeLocationService();
  }
  return RealLocationService();
});
