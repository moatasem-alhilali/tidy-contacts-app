import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_manager/src/core/either/either.dart';

/// Enhanced location service with proper error handling, result types, and advanced features
class ServicesLocation {
  ServicesLocation._();

  static final ServicesLocation _instance = ServicesLocation._();
  static ServicesLocation get instance => _instance;

  /// Default location accuracy settings
  static const LocationAccuracy _defaultAccuracy = LocationAccuracy.high;
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const Duration _defaultInterval = Duration(seconds: 1);

  /// Check if location services are enabled
  Future<bool> isLocationEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Check current location permission status
  Future<LocationPermission> getPermissionStatus() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      return LocationPermission.denied;
    }
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    try {
      return await Geolocator.requestPermission();
    } catch (e) {
      return LocationPermission.denied;
    }
  }

  /// Determine position with comprehensive error handling
  Future<Either<LocationError, Position>> determinePosition({
    LocationAccuracy accuracy = _defaultAccuracy,
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      // Check if location services are enabled
      final isEnabled = await isLocationEnabled();
      if (!isEnabled) {
        return const Left(
          LocationError(
            type: LocationErrorType.serviceDisabled,
            message: 'Location services are disabled',
            code: 'LOC_001',
          ),
        );
      }

      // Check and request permissions
      final permission = await _handlePermissions();
      if (permission.isLeft) {
        return Left(permission.left);
      }

      // Get current position with timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeout,
      );

      return Right(position);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  /// Get current position with custom settings
  Future<Either<LocationError, Position>> getCurrentPosition({
    LocationAccuracy accuracy = _defaultAccuracy,
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeout,
      );
      return Right(position);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  /// Get last known position (cached)
  Future<Either<LocationError, Position?>> getLastKnownPosition() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      return Right(position);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  /// Get position stream for continuous location updates
  Stream<Either<LocationError, Position>> getPositionStream({
    LocationAccuracy accuracy = _defaultAccuracy,
    Duration interval = _defaultInterval,
    Duration timeout = _defaultTimeout,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        timeLimit: timeout,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).map(Right<LocationError, Position>.new).handleError((error) {
      return Left<LocationError, Position>(_handleException(error));
    });
  }

  /// Calculate distance between two positions
  double calculateDistance(Position start, Position end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// Calculate bearing between two positions
  double calculateBearing(Position start, Position end) {
    return Geolocator.bearingBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// Check if a position is within a certain radius of another position
  bool isWithinRadius(Position center, Position target, double radiusInMeters) {
    final distance = calculateDistance(center, target);
    return distance <= radiusInMeters;
  }

  /// Get address from coordinates (reverse geocoding)
  // Future<Either<LocationError, List<Placemark>>> getAddressFromCoordinates(
  //   double latitude,
  //   double longitude,
  // ) async {
  //   try {
  //     final placemarks = await placemarkFromCoordinates(latitude, longitude);
  //     return Right(placemarks);
  //   } catch (e) {
  //     return Left(_handleException(e));
  //   }
  // }

  /// Get coordinates from address (geocoding)
  // Future<Either<LocationError, List<Location>>> getCoordinatesFromAddress(
  //   String address,
  // ) async {
  //   try {
  //     final locations = await locationFromAddress(address);
  //     return Right(locations);
  //   } catch (e) {
  //     return Left(_handleException(e));
  //   }
  // }

  /// Check if location permission is permanently denied
  Future<bool> isLocationPermissionPermanentlyDenied() async {
    final permission = await getPermissionStatus();
    return permission == LocationPermission.deniedForever;
  }

  /// Open app settings if permission is permanently denied
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      return false;
    }
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      return false;
    }
  }

  /// Handle location permissions with proper error handling
  Future<Either<LocationError, LocationPermission>> _handlePermissions() async {
    try {
      var permission = await getPermissionStatus();

      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(
            LocationError(
              type: LocationErrorType.permissionDenied,
              message: 'Location permission denied',
              code: 'LOC_002',
            ),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(
          LocationError(
            type: LocationErrorType.permissionPermanentlyDenied,
            message: 'Location permissions are permanently denied',
            code: 'LOC_003',
          ),
        );
      }

      return Right(permission);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  /// Handle exceptions and convert them to LocationError
  LocationError _handleException(dynamic error) {
    if (error is TimeoutException) {
      return const LocationError(
        type: LocationErrorType.timeout,
        message: 'Location request timed out',
        code: 'LOC_004',
      );
    }

    if (error is PlatformException) {
      switch (error.code) {
        case 'PERMISSION_DENIED':
          return const LocationError(
            type: LocationErrorType.permissionDenied,
            message: 'Location permission denied',
            code: 'LOC_002',
          );
        case 'LOCATION_SERVICE_DISABLED':
          return const LocationError(
            type: LocationErrorType.serviceDisabled,
            message: 'Location services are disabled',
            code: 'LOC_001',
          );
        case 'LOCATION_UPDATE_FAILURE':
          return const LocationError(
            type: LocationErrorType.updateFailure,
            message: 'Failed to get location update',
            code: 'LOC_005',
          );
        default:
          return LocationError(
            type: LocationErrorType.unknown,
            message: error.message ?? 'Unknown location error',
            code: 'LOC_000',
          );
      }
    }

    return LocationError(
      type: LocationErrorType.unknown,
      message: error.toString(),
      code: 'LOC_000',
    );
  }

  /// Check if device supports location services
  Future<bool> isLocationSupported() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Get location accuracy description
  String getAccuracyDescription(LocationAccuracy accuracy) {
    switch (accuracy) {
      case LocationAccuracy.lowest:
        return 'Lowest (3km)';
      case LocationAccuracy.low:
        return 'Low (1km)';
      case LocationAccuracy.medium:
        return 'Medium (100m)';
      case LocationAccuracy.high:
        return 'High (10m)';
      case LocationAccuracy.best:
        return 'Best (3m)';
      case LocationAccuracy.bestForNavigation:
        return 'Best for Navigation (3m)';
      default:
        return 'Unknown';
    }
  }

  /// Get recommended accuracy based on use case
  LocationAccuracy getRecommendedAccuracy(LocationUseCase useCase) {
    switch (useCase) {
      case LocationUseCase.navigation:
        return LocationAccuracy.bestForNavigation;
      case LocationUseCase.tracking:
        return LocationAccuracy.high;
      case LocationUseCase.general:
        return LocationAccuracy.medium;
      case LocationUseCase.rough:
        return LocationAccuracy.low;
    }
  }
}

/// Location error types
enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  timeout,
  updateFailure,
  unknown,
}

/// Location use cases for accuracy recommendations
enum LocationUseCase { navigation, tracking, general, rough }

/// Location error model
class LocationError {
  const LocationError({
    required this.type,
    required this.message,
    required this.code,
    this.details,
  });

  final LocationErrorType type;
  final String message;
  final String code;
  final Map<String, dynamic>? details;

  @override
  String toString() => 'LocationError($code): $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationError &&
        other.type == type &&
        other.message == message &&
        other.code == code;
  }

  @override
  int get hashCode => Object.hash(type, message, code);
}
