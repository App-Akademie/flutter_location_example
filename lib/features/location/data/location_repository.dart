import 'package:flutter_location_example/features/location/domain/location_model.dart';

/// Abstrakte Klasse, die die Methoden für den Zugriff auf den Standort
/// definiert.
///
/// Man kann abfragen, ob die Berechtigung für den Zugriff auf den Standort
/// erteilt wurde, die Berechtigung anfordern und die aktuellen Standortdaten
/// abfragen.
abstract class LocationRepository {
  /// Überprüfen, ob die Berechtigung für den Zugriff auf den Standort
  /// erteilt wurde.
  ///
  /// Gibt [true] zurück, wenn die Berechtigung erteilt wurde, sonst [false].
  Future<bool> isPermissionEnabled();

  /// Berechtigung für den Zugriff auf den Standort anfordern.
  ///
  /// Gibt [true] zurück, wenn die Berechtigung erteilt wurde, sonst [false].
  /// Wirft Exceptions, wenn die Berechtigungen nicht erteilt werden.
  /// - [ServiceDisabledException], wenn der Location Service deaktiviert ist.
  /// - [PermissionDeniedOnceException], wenn die Berechtigungen verweigert wurden.
  /// - [PermissionDeniedForeverException], wenn die Berechtigungen dauerhaft
  /// verweigert wurden.
  /// - [Exception], wenn ein anderer Fehler auftritt.
  Future<bool> getPermissions();

  /// Stream, der die aktuellen Standortdaten liefert.
  ///
  /// Gibt die aktuellen Standortdaten als [LocationModel] zurück.
  Stream<LocationModel> get locations;
}

/// Exceptions, die bei der Standortabfrage auftreten können.
/// Weil es eine "Sealed Class" ist, kann Dart checken, ob alle Fälle abgefragt
/// werden, wenn zum Beispiel ein `switch`-Statement verwendet wird.
sealed class LocationException implements Exception {
  LocationException({required this.message});
  final String message;
}

class ServiceDisabledException extends LocationException {
  ServiceDisabledException() : super(message: 'Location service is disabled.');
}

class PermissionDeniedOnceException extends LocationException {
  PermissionDeniedOnceException()
      : super(message: 'Location permissions are denied.');
}

class PermissionDeniedForeverException extends LocationException {
  PermissionDeniedForeverException()
      : super(
            message:
                'Location permissions are permanently denied, we cannot request permissions.');
}
