import 'package:flutter/material.dart';
import 'package:flutter_location_example/features/location/presentation/location_controller.dart';
import 'package:flutter_location_example/main_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationController(),
      child: const MainApp(),
    ),
  );
}
