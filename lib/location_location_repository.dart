import 'dart:developer';

import 'package:flutter_location_example/location_model.dart';
import 'package:flutter_location_example/location_repository.dart';
import 'package:location/location.dart';

/// LocationRepository implementation mit dem `location` package.
class LocationLocationRepository extends LocationRepository {
  final Location _location = Location();

  @override
  Future<bool> isPermissionEnabled() async {
    final permission = await _location.hasPermission();
    return permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited;
  }

  @override
  Future<bool> getPermissions() async {
    bool serviceEnabled;
    PermissionStatus permission;

    // Test if location services are enabled.
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }
    }

    permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission == PermissionStatus.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == PermissionStatus.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  @override
  Stream<LocationModel> get locations => _location.onLocationChanged.map((l) {
        log("Got loctation in repository :)");
        return LocationModel(
            latitude: l.latitude ?? 42.0, longitude: l.longitude ?? -69.0);
      });
  // /// Will return Stuttgart :) 48.783333, 9.183333
  // Stream<LocationModel> get locations => Stream.value(
  //       LocationModel(latitude: 48.783333, longitude: 9.183333),
  //     );
}
