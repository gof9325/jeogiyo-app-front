import 'package:fl_location/fl_location.dart';

Future<bool> _checkAndRequestPermission({bool? background}) async {
  if (!await FlLocation.isLocationServicesEnabled) {
    // Location services is disabled.
    return false;
  }

  LocationPermission permission = await FlLocation.checkLocationPermission();
  if (permission == LocationPermission.deniedForever) {
    // Location permission has been permanently denied.
    return false;
  } else if (permission == LocationPermission.denied) {
    // Ask the user for location permission.
    permission = await FlLocation.requestLocationPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Location permission has been denied.
      return false;
    }
  }

  // Location permission must always be granted (LocationPermission.always)
  // to collect location data in the background.
  if (background == true && permission == LocationPermission.whileInUse) {
    // Location permission must always be granted to collect location in the background.
    return false;
  }

  return true;
}

Future<Map<String, double>?> getLocation() async {
  if (await _checkAndRequestPermission()) {
    final Location location = await FlLocation.getLocation();
    print('location: ${location.toJson()}');
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
    };
  }
  return null;
}
