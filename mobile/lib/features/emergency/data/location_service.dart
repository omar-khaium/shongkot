import '../domain/rapid_emergency_request.dart';

/// Abstract location service interface
/// TODO: Implement real location service using geolocator or similar package
abstract class LocationService {
  /// Get current location
  /// Returns null if location is unavailable or permission denied
  Future<EmergencyLocation?> getCurrentLocation();

  /// Check if location services are enabled
  Future<bool> isLocationEnabled();

  /// Request location permission
  Future<bool> requestLocationPermission();
}
