import 'package:flutter_location_example/features/location/data/location_repository.dart';
import 'package:flutter_location_example/features/location/domain/location_model.dart';
import 'package:location/location.dart';

/// LocationRepository Implementierung mit dem `location` Package.
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

    // Checken, ob der Service aktiviert und verfügbar ist.
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // Versuchen den Service zu aktivieren bzw. aktivieren zu lassen.
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        // Der Location Service ist nicht aktiviert, wir können
        // nicht fortfahren und die Position abfragen. Wir
        // fordern die Benutzer der App auf, den Location Service
        // zu aktivieren.
        throw Exception('Location service is disabled.');
      }
    }

    permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission == PermissionStatus.denied) {
        // Permissions wurden verweigert, das nächste Mal
        // kann man versuchen, die Berechtigungen erneut
        // anzufordern (hier wird auch true zurückgegeben,
        // wenn shouldShowRequestPermissionRationale von
        // Android true zurückgibt. Laut Android-Richtlinien
        // sollte die App jetzt eine erläuternde UI anzeigen.
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == PermissionStatus.deniedForever) {
      // Berechtigungen wurden dauerhaft verweigert, es kann
      // keine Berechtigungen mehr angefordert werden.
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  @override
  Stream<LocationModel> get locations => _location.onLocationChanged.map((l) {
        return LocationModel(
            latitude: l.latitude ?? 42.0, longitude: l.longitude ?? -69.0);
      });
}
