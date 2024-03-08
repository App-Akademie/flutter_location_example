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
    if (!isPermissionEnabled) {
      // Berechtigungen anfordern

      isPermissionEnabled = await locationRepository.getPermissions();
    }

    // Wenn der Benutzer immer noch keine Berechtigung gegeben hat,
    // dann können wir nicht weitermachen.
    if (!isPermissionEnabled) {
      status = LocationStatus.permissionDenied;
      notifyListeners();

      return;
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
        // TODO set right status depending on error
        status = LocationStatus.permissionDenied;
        notifyListeners();
      },
      onDone: () {
        notifyListeners();
      },
      // Wenn es Fehler gab, alles abbrechen und Ende.
      cancelOnError: true,
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
