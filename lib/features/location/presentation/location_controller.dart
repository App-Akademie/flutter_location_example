import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_location_example/features/location/data/geolocator_location_repository.dart';
import 'package:flutter_location_example/features/location/data/location_repository.dart';
import 'package:flutter_location_example/features/location/domain/location_model.dart';

class LocationController extends ChangeNotifier {
  LocationController() {
    // Die Locations vom Repository holen und weitergeben.
    _listenToLocations();
  }

  final LocationRepository locationRepository = GeolocatorLocationRepository();

  LocationStatus status = LocationStatus.loading;

  LocationModel? _currentLocation;

  /// Property, das den aktuellen Standort anzeigt (read only).
  LocationModel? get currentLocation => _currentLocation;

  void _listenToLocations() async {
    // Checken, ob wir die Berechtigung haben und evtl. anfordern.
    bool isPermissionEnabled = await locationRepository.isPermissionEnabled();
    // Berechtigungen anfordern falls nötig.
    if (!isPermissionEnabled) {
      // Hierbei müssen die verschiedenen Exceptions abgefangen werden.
      // Je nach Exception muss der Status gesetzt werden, damit die UI
      // entsprechend anzeigen kann, was los ist.
      try {
        status = LocationStatus.permissionRequired;
        notifyListeners();

        isPermissionEnabled = await locationRepository.getPermissions();
      } on ServiceDisabledException {
        status = LocationStatus.permissionDenied;
        notifyListeners();

        return;
      } on PermissionDeniedOnceException {
        status = LocationStatus.permissionDenied;
        notifyListeners();

        return;
      } on PermissionDeniedForeverException {
        status = LocationStatus.permissionDeniedForever;
        notifyListeners();

        return;
      } on Exception catch (e) {
        log(e.toString());
        status = LocationStatus.permissionDenied;
        notifyListeners();

        return;
      }
    }

    // Wenn wir die Berechtigung haben, kann der Standort abonniert werden.
    locationRepository.locations.listen(
      // Alles supi, Locations kommen raus und an.
      (location) {
        _currentLocation = location;
        status = LocationStatus.active;
        notifyListeners();
      },
      // Gab nen Fehler. Das muss irgendwie weiter kommuniziert werden.
      onError: (error, stacktrace) {
        log(error.toString());
        log(stacktrace.toString());
        // TODO: Set right status depending on error.
        status = LocationStatus.permissionDenied;
        notifyListeners();
      },
      onDone: () {
        notifyListeners();
      },
    );
  }
}

/// In welchem Zustand ist der Location Access gerade?
enum LocationStatus {
  /// Wird aktuell geladen (initialer Zustand).
  loading,

  /// Alles gut, wir haben die Berechtigungen.
  active,

  /// Wir brauchen noch Berechtigungen.
  permissionRequired,

  /// Wir haben die Berechtigungen nicht bekommen.
  permissionDenied,

  /// Wir haben die Berechtigungen nicht bekommen und der Nutzer hat gesagt,
  /// dass er sie nie geben wird.
  permissionDeniedForever,
}
