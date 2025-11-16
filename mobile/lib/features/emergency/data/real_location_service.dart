import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../domain/rapid_emergency_request.dart';
import 'location_service.dart';

/// Real GPS location service implementation using geolocator
/// Provides accurate location tracking with battery optimization
class RealLocationService implements LocationService {
  /// Cached location for offline scenarios
  EmergencyLocation? _cachedLocation;
  
  /// Timestamp of the cached location
  DateTime? _cachedLocationTimestamp;
  
  /// Cache validity duration (5 minutes)
  static const _cacheValidityDuration = Duration(minutes: 5);

  @override
  Future<EmergencyLocation?> getCurrentLocation() async {
    try {
      debugPrint('📍 RealLocationService: Getting current location...');

      // Check if location services are enabled
      final serviceEnabled = await isLocationEnabled();
      if (!serviceEnabled) {
        debugPrint('📍 Location services are disabled');
        return _getCachedLocationIfValid();
      }

      // Check location permission
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        debugPrint('📍 Location permission not granted');
        return _getCachedLocationIfValid();
      }

      // Get current position with high accuracy
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Only update if moved 10 meters
        ),
      );

      final location = _positionToEmergencyLocation(position);
      
      // Cache the location
      _cachedLocation = location;
      _cachedLocationTimestamp = DateTime.now();
      
      debugPrint('📍 Location obtained: ${location.latitude}, ${location.longitude} '
          '(accuracy: ${location.accuracy?.toStringAsFixed(1)}m, '
          'level: ${location.accuracyLevel})');

      return location;
    } catch (e) {
      debugPrint('📍 Error getting location: $e');
      return _getCachedLocationIfValid();
    }
  }

  @override
  Future<bool> isLocationEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('📍 Error checking location service: $e');
      return false;
    }
  }

  @override
  Future<bool> requestLocationPermission() async {
    try {
      debugPrint('📍 Requesting location permission...');

      // Check current permission status
      var permission = await ph.Permission.location.status;
      debugPrint('📍 Current permission status: $permission');

      if (permission.isGranted) {
        return true;
      }

      if (permission.isDenied) {
        // Request permission
        permission = await ph.Permission.location.request();
        debugPrint('📍 Permission request result: $permission');
        
        if (permission.isGranted) {
          return true;
        }
      }

      // If permission is permanently denied, guide user to settings
      if (permission.isPermanentlyDenied) {
        debugPrint('📍 Permission permanently denied. User needs to enable in settings.');
        // In a real app, you might want to show a dialog here
        return false;
      }

      return false;
    } catch (e) {
      debugPrint('📍 Error requesting location permission: $e');
      return false;
    }
  }

  /// Request background location permission (Android 10+)
  /// This is separate from regular location permission
  Future<bool> requestBackgroundLocationPermission() async {
    try {
      debugPrint('📍 Requesting background location permission...');

      // First ensure we have regular location permission
      final hasLocationPermission = await requestLocationPermission();
      if (!hasLocationPermission) {
        debugPrint('📍 Cannot request background permission without location permission');
        return false;
      }

      // Check background location permission
      var permission = await ph.Permission.locationAlways.status;
      debugPrint('📍 Current background permission status: $permission');

      if (permission.isGranted) {
        return true;
      }

      if (permission.isDenied) {
        // Request background permission
        permission = await ph.Permission.locationAlways.request();
        debugPrint('📍 Background permission request result: $permission');
        
        if (permission.isGranted) {
          return true;
        }
      }

      if (permission.isPermanentlyDenied) {
        debugPrint('📍 Background permission permanently denied.');
        return false;
      }

      return false;
    } catch (e) {
      debugPrint('📍 Error requesting background location permission: $e');
      return false;
    }
  }

  /// Start listening to location updates (for background tracking during emergency)
  /// Returns a stream of location updates with configurable intervals
  Stream<EmergencyLocation> getLocationStream({
    Duration interval = const Duration(seconds: 30),
  }) {
    debugPrint('📍 Starting location stream with ${interval.inSeconds}s interval...');
    
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).map((position) {
      final location = _positionToEmergencyLocation(position);
      
      // Update cache
      _cachedLocation = location;
      _cachedLocationTimestamp = DateTime.now();
      
      debugPrint('📍 Location update: ${location.latitude}, ${location.longitude} '
          '(accuracy: ${location.accuracy?.toStringAsFixed(1)}m)');
      
      return location;
    });
  }

  /// Check if we have the required location permission
  Future<bool> _checkLocationPermission() async {
    try {
      final permission = await ph.Permission.location.status;
      return permission.isGranted;
    } catch (e) {
      debugPrint('📍 Error checking location permission: $e');
      return false;
    }
  }

  /// Convert Geolocator Position to EmergencyLocation
  EmergencyLocation _positionToEmergencyLocation(Position position) {
    final accuracyLevel = 
        LocationAccuracy.fromAccuracyValue(position.accuracy);
    
    return EmergencyLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      timestamp: position.timestamp,
      accuracyLevel: accuracyLevel,
    );
  }

  /// Get cached location if it's still valid
  EmergencyLocation? _getCachedLocationIfValid() {
    if (_cachedLocation == null || _cachedLocationTimestamp == null) {
      debugPrint('📍 No cached location available');
      return null;
    }

    final age = DateTime.now().difference(_cachedLocationTimestamp!);
    if (age > _cacheValidityDuration) {
      debugPrint('📍 Cached location is too old (${age.inMinutes} minutes)');
      return null;
    }

    debugPrint('📍 Returning cached location (age: ${age.inSeconds}s)');
    return _cachedLocation;
  }

  /// Clear the location cache
  void clearCache() {
    debugPrint('📍 Clearing location cache');
    _cachedLocation = null;
    _cachedLocationTimestamp = null;
  }

  /// Get last known position (battery-efficient fallback)
  Future<EmergencyLocation?> getLastKnownLocation() async {
    try {
      debugPrint('📍 Getting last known location...');
      
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) {
        debugPrint('📍 No last known position available');
        return _getCachedLocationIfValid();
      }

      final location = _positionToEmergencyLocation(position);
      debugPrint('📍 Last known location: ${location.latitude}, ${location.longitude}');
      
      return location;
    } catch (e) {
      debugPrint('📍 Error getting last known location: $e');
      return _getCachedLocationIfValid();
    }
  }

  /// Check distance from a reference point (useful for geo-fencing)
  Future<double?> getDistanceFromPoint({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final currentLocation = await getCurrentLocation();
      if (currentLocation == null) {
        return null;
      }

      final distance = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        latitude,
        longitude,
      );

      debugPrint('📍 Distance from point: ${distance.toStringAsFixed(1)}m');
      return distance;
    } catch (e) {
      debugPrint('📍 Error calculating distance: $e');
      return null;
    }
  }
}
