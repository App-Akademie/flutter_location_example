import 'package:flutter/material.dart';
import 'package:flutter_location_example/location_controller.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = context.watch<LocationController>();

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Current Position:'),
              if (!locationController.hasErrorOcurred &&
                  locationController.currentLocation == null)
                const CircularProgressIndicator(),
              if (locationController.hasErrorOcurred)
                const Text("Feeeehler!!!"),
              if (locationController.currentLocation != null)
                Text(
                  "${locationController.currentLocation?.latitude}, ${locationController.currentLocation?.longitude}",
                ),
            ],
          ),
        ),
      ),
    );
  }
}
