import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_location_example/location_model.dart';
import 'package:flutter_location_example/location_repository.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends ChangeNotifier {
  LocationController() {
    // Die Locations vom Repository holen und weitergeben.
    _listenToLocations();
  }

  final LocationRepository locationRepository = LocationRepository();

  bool hasErrorOcurred = false;

  LocationModel? _currentLocation;

  LocationModel? get currentLocation => _currentLocation;

  void _listenToLocations() {
    log("Listening to locations");
    locationRepository.locations.listen(
      // Alles supi, Locations kommen raus und an.
      (Position locationData) {
        log("Got location data: $locationData");
        _currentLocation = LocationModel(
          latitude: locationData.latitude,
          //latitude: 0.0,
          longitude: locationData.longitude,
          //longitude: 0.0,
        );
        notifyListeners();
      },
      // Gab nen Fehler, das wollen wir weitergeben.
      onError: (error, stacktrace) {
        log("Error when getting location data.");
        log(error.toString());
        log(stacktrace.toString());
        hasErrorOcurred = true;
        notifyListeners();
      },
      onDone: () {
        log("Done with getting locations");
        notifyListeners();
      },
      // Wenn es Fehler gab, alles abbrechen und Ende.
      cancelOnError: true,
    );
  }
}
