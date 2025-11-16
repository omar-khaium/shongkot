import '../domain/rapid_emergency_request.dart';

/// Abstract location service interface
/// Implemented by RealLocationService for production GPS tracking
/// and FakeLocationService for development/testing
abstract class LocationService {
  /// Get current location with high accuracy
  /// Returns null if location is unavailable or permission denied
  /// May return cached location if fresh location cannot be obtained
  Future<EmergencyLocation?> getCurrentLocation();

  /// Check if location services are enabled on the device
  /// Returns true if GPS/location services are active
  Future<bool> isLocationEnabled();

  /// Request location permission from the user
  /// Returns true if permission is granted, false otherwise
  /// Should handle both foreground (when-in-use) permissions
  Future<bool> requestLocationPermission();
}
