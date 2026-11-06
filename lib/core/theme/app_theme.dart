import 'package:flutter/material.dart';
import 'app_theme_data.dart';

abstract class AppTheme {
  static ThemeData get light => AppThemeData.lightTheme;
  static ThemeData get dark => AppThemeData.darkTheme;
}

/// use case
/// Text(
///   'Hello',
///   style: Theme.of(context).textTheme.bodyLarge,
/// );
/// or
/// Container(color: Theme.of(context).colorScheme.surface);