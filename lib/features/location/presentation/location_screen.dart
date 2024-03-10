import 'package:flutter/material.dart';
import 'package:flutter_location_example/features/location/presentation/location_controller.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = context.watch<LocationController>();

    return Scaffold(
      // Zeigen, ob wir Permission haben oder noch brauchen oder was auch immer.
      // Mögliche Fälle:
      // - Permission wird angefragt
      // - Permission wurde erteilt
      // - Permission wurde verweigert
      // - Permission wurde dauerhaft verweigert
      appBar: AppBar(title: const LocationStatusIcons()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Position:'),
            // switch (locationController.status) {
            //   LocationStatus.loading => const CircularProgressIndicator(),
            //   LocationStatus.permissionRequired =>
            //     const Text("Permission required"),
            //   LocationStatus.permissionDenied ||
            //   LocationStatus.permissionDeniedForever =>
            //     const Text("Keine Permission"),
            //   LocationStatus.active => Text(
            //       "${locationController.currentLocation?.latitude}, ${locationController.currentLocation?.longitude}",
            //     ),
            // },
            if (locationController.status == LocationStatus.loading)
              const CircularProgressIndicator(),
            if (locationController.status == LocationStatus.permissionRequired)
              const Text("Permission required"),
            if (locationController.status == LocationStatus.permissionDenied ||
                locationController.status ==
                    LocationStatus.permissionDeniedForever)
              const Text("Keine Permission"),
            if (locationController.status == LocationStatus.active)
              Text(
                "${locationController.currentLocation?.latitude}, ${locationController.currentLocation?.longitude}",
              ),
          ],
        ),
      ),
    );
  }
}

class LocationStatusIcons extends StatelessWidget {
  const LocationStatusIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = context.watch<LocationController>();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading.
          Icon(
            Icons.replay_circle_filled,
            color: locationController.status == LocationStatus.loading
                ? Colors.green
                : Colors.grey,
          ),
          const SizedBox(width: 16),
          // Permission required.
          Icon(
            Icons.not_listed_location_outlined,
            color:
                locationController.status == LocationStatus.permissionRequired
                    ? Colors.green
                    : Colors.grey,
          ),
          const SizedBox(width: 16),
          // Active.
          Icon(
            Icons.my_location,
            color: locationController.status == LocationStatus.active
                ? Colors.green
                : Colors.grey,
          ),
          const SizedBox(width: 16),
          // Permission denied.
          Icon(
            Icons.location_disabled,
            color: locationController.status == LocationStatus.permissionDenied
                ? Colors.red
                : Colors.grey,
          ),
          const SizedBox(width: 16),
          // Permission denied FOREVER :(
          Icon(
            //Icons.outlet_outlined,
            //Icons.warning_amber_outlined,
            Icons.sick_outlined,
            color: locationController.status ==
                    LocationStatus.permissionDeniedForever
                ? Colors.red
                : Colors.grey,
          ),
        ],
      ),
    );
  }
}
