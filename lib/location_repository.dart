import 'package:geolocator/geolocator.dart';

class LocationRepository {
  Stream<Position> get locations => Geolocator.getPositionStream();
  // /// Will return Stuttgart :) 48.783333, 9.183333
  // Stream<LocationModel> get locations => Stream.value(
  //       LocationModel(latitude: 48.783333, longitude: 9.183333),
  //     );
}
