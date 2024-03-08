import 'package:flutter/material.dart';
import 'package:flutter_location_example/features/location/presentation/location_controller.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = context.watch<LocationController>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Position:'),
            switch (locationController.status) {
              LocationStatus.loading => const CircularProgressIndicator(),
              LocationStatus.permissionRequired =>
                const Text("Permission required"),
              LocationStatus.permissionDenied ||
              LocationStatus.permissionDeniedForever =>
                const Text("Keine Permission"),
              LocationStatus.active => Text(
                  "${locationController.currentLocation?.latitude}, ${locationController.currentLocation?.longitude}",
                ),
            },
            // if (locationController.status == LocationStatus.loading)
            //   const CircularProgressIndicator(),
            // if (locationController.status == LocationStatus.permissionRequired)
            //   const Text("Permission required"),
            // if (locationController.status == LocationStatus.permissionDenied ||
            //     locationController.status ==
            //         LocationStatus.permissionDeniedForever)
            //   const Text("Keine Permission"),
            // if (locationController.status == LocationStatus.active)
            //   Text(
            //     "${locationController.currentLocation?.latitude}, ${locationController.currentLocation?.longitude}",
            //   ),
          ],
        ),
      ),
    );
  }
}
