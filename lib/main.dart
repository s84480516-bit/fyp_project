import 'app/injection_container.dart';
import 'core/utils/system_utils.dart';
import 'package:flutter/material.dart';
import 'core/services/logger/logger_service.dart';
import 'package:cleanarchitecturetemplate/app/app_name.dart';
import 'package:cleanarchitecturetemplate/core/config/responsive_config.dart';

void main() async {
  // Ensure flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Log app start
  LoggerService(className: "main").info('App starting...');

  // Set system styles
  SystemUtils.setDefaultSystemUI();

  // Lock orientation
  await SystemUtils.lockOrientation();

  // Initializing dependencies
  await initializeDependencies();

  runApp(
    ResponsiveProvider(
      mobileSize: Size(360, 800),
      tabletSize: Size(800, 1280),
      isDebugPrint: true,
      child: const AppName(),
    ),
  );
}
