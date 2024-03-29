import 'package:flutter_location_example/features/location/data/location_repository.dart';
import 'package:flutter_location_example/features/location/domain/location_model.dart';
import 'package:geolocator/geolocator.dart';

/// LocationRepository Implementierung mit dem `geolocator` Package.
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

    // Checken, ob der Service aktiviert und verfügbar ist.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Der Location Service ist nicht aktiviert, wir können
      // nicht fortfahren und die Position abfragen. Wir
      // fordern die Benutzer der App auf, den Location Service
      // zu aktivieren.
      throw ServiceDisabledException();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions wurden verweigert, das nächste Mal
        // kann man versuchen, die Berechtigungen erneut
        // anzufordern (hier wird auch true zurückgegeben,
        // wenn shouldShowRequestPermissionRationale von
        // Android true zurückgibt. Laut Android-Richtlinien
        // sollte die App jetzt eine erläuternde UI anzeigen.
        throw PermissionDeniedOnceException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Berechtigungen wurden dauerhaft verweigert, es kann
      // keine Berechtigungen mehr angefordert werden.
      throw PermissionDeniedForeverException();
    }

    return true;
  }

  @override
  Stream<LocationModel> get locations => Geolocator.getPositionStream()
      .map((p) => LocationModel(latitude: p.latitude, longitude: p.longitude));
}
