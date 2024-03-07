import 'package:flutter_location_example/location_model.dart';

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
  Future<bool> getPermissions();

  /// Stream, der die aktuellen Standortdaten liefert.
  ///
  /// Gibt die aktuellen Standortdaten als [LocationModel] zurück.
  Stream<LocationModel> get locations;
}
