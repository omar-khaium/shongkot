import 'package:flutter/foundation.dart';
import '../domain/rapid_emergency_request.dart';
import 'location_service.dart';

/// Fake location service for MVP
/// Returns a placeholder location
/// TODO: Replace with real location service implementation using geolocator
class FakeLocationService implements LocationService {
  @override
  Future<EmergencyLocation?> getCurrentLocation() async {
    debugPrint('📍 FakeLocationService: Getting location...');
    
    // Simulate location fetch delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Return a fake location (Dhaka, Bangladesh coordinates)
    // TODO: Replace with actual GPS coordinates
    return const EmergencyLocation(
      latitude: 23.8103,
      longitude: 90.4125,
    );
  }

  @override
  Future<bool> isLocationEnabled() async {
    // For MVP, assume location is always enabled
    return true;
  }

  @override
  Future<bool> requestLocationPermission() async {
    // For MVP, assume permission is always granted
    return true;
  }
}
