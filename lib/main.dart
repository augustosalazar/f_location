import 'package:f_location/ui/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'domain/use_case/locator_service.dart';
import 'ui/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );
  Get.put(LocatorService());
  Get.put(LocationController());
  runApp(const MyApp());
}
