import 'package:flutter/material.dart';
import 'package:flutter_location_example/features/location/presentation/location_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LocationScreen(),
    );
  }
}
