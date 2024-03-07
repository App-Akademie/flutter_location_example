import 'package:flutter_location_example/location_model.dart';
import 'package:flutter_location_example/location_repository.dart';
import 'package:geolocator/geolocator.dart';

/// LocationRepository implementation mit dem `geolocator` package.
class GeolocatorLocationRepository extends LocationRepository {
  @override
  Future<bool> isPermissionEnabled() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> getPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }

  @override
  Stream<LocationModel> get locations => Geolocator.getPositionStream()
      .map((p) => LocationModel(latitude: p.latitude, longitude: p.longitude));
  // /// Will return Stuttgart :) 48.783333, 9.183333
  // Stream<LocationModel> get locations => Stream.value(
  //       LocationModel(latitude: 48.783333, longitude: 9.183333),
  //     );
}
