import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_location_example/geolocator_location_repository.dart';
import 'package:flutter_location_example/location_model.dart';
import 'package:flutter_location_example/location_repository.dart';

class LocationController extends ChangeNotifier {
  LocationController() {
    // Die Locations vom Repository holen und weitergeben.
    _listenToLocations();
  }

  final LocationRepository locationRepository = GeolocatorLocationRepository();

  bool hasErrorOcurred = false;

  LocationModel? _currentLocation;

  LocationModel? get currentLocation => _currentLocation;

  void _listenToLocations() async {
    if (await locationRepository.isPermissionEnabled()) {
      locationRepository.locations.listen(
        // Alles supi, Locations kommen raus und an.
        (location) {
          _currentLocation = location;
          notifyListeners();
        },
        // Gab nen Fehler, das wollen wir weitergeben.
        onError: (error, stacktrace) {
          log(error.toString());
          log(stacktrace.toString());
          hasErrorOcurred = true;
          notifyListeners();
        },
        onDone: () {
          notifyListeners();
        },
        // Wenn es Fehler gab, alles abbrechen und Ende.
        cancelOnError: true,
      );
    } else {
      await locationRepository.getPermissions();
      notifyListeners();
    }
  }
}
