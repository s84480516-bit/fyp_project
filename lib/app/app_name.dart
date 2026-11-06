import '../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/theme_provider.dart';
import 'package:cleanarchitecturetemplate/core/router/app_router.dart';
import 'package:cleanarchitecturetemplate/app/injection_container.dart';

import '../features/boycott_check/presentation/providers/boycott_check_provider.dart';
import '../features/ingredient_analysis/presentation/providers/ingredient_analysis_provider.dart';
import '../features/product_scanner/presentation/providers/scanner_provider.dart';
import '../features/recommendations/presentation/providers/recommendations_provider.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di<ThemeProvider>()),
        ChangeNotifierProvider(create: (_) => di<ScannerProvider>()),
        ChangeNotifierProvider(create: (_) => di<IngredientAnalysisProvider>()),
        ChangeNotifierProvider(create: (_) => di<BoycottCheckProvider>()),
        ChangeNotifierProvider(create: (_) => di<RecommendationsProvider>()),
      ], // contain global and feature providers.
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, _) {
          return MaterialApp.router(
            title: 'ScanEth AI',
            debugShowCheckedModeBanner: false,

            // Themes
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,

            // Router
            routerConfig: AppRouter.appRouter,
          );
        },
      ),
    );
  }
}
