import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cleanarchitecturetemplate/core/router/route_names.dart';
import '../../features/product_scanner/domain/entities/product.dart';
import '../../features/product_scanner/presentation/screens/scanner_screen.dart';
import '../../features/ingredient_analysis/presentation/screens/product_details_screen.dart';
import '../../features/boycott_check/presentation/screens/boycott_analysis_screen.dart';
import '../../features/recommendations/presentation/screens/alternatives_screen.dart';

class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: RouteNames.scanner,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouteNames.scanner,
        name: 'scanner',
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: RouteNames.productDetails,
        name: 'productDetails',
        builder: (context, state) {
          final product = state.extra as Product? ??
              const Product(
                id: '7394376616030',
                barcode: '7394376616030',
                name: 'Oatly Barista Edition Oat Milk',
                brand: 'Oatly',
                imageUrl:
                    'https://images.openfoodfacts.org/images/products/739/437/661/6030/front_en.169.400.jpg',
                quantity: '1 L',
                ingredientsText:
                    'Water, Oats 10%, Rapeseed oil, Dipotassium phosphate, Calcium carbonate, Sea salt',
                rawIngredients: [
                  'Water',
                  'Oats',
                  'Rapeseed oil',
                  'Dipotassium phosphate',
                  'Calcium carbonate',
                  'Sea salt',
                ],
                ecoScore: 'B',
                novaGroup: 3,
                nutriScore: 'B',
                ethicsScore: 7.8,
                origins: 'Sweden / EU Agriculture',
                labels: ['Vegan', 'FSC Recyclable'],
                isBoycotted: false,
              );
          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: RouteNames.boycottAnalysis,
        name: 'boycottAnalysis',
        builder: (context, state) {
          final product = state.extra as Product? ??
              const Product(
                id: '7613035345678',
                barcode: '7613035345678',
                name: 'Nesquik Chocolate Drink Mix',
                brand: 'Nestlé',
                imageUrl:
                    'https://images.openfoodfacts.org/images/products/761/303/534/5678/front_en.4.400.jpg',
                quantity: '400 g',
                ingredientsText:
                    'Sugar, Cocoa powder, Soy lecithin, Salt, Artificial flavour (Vanillin), Cinnamon, Palm oil derivatives',
                rawIngredients: [
                  'Sugar',
                  'Cocoa powder',
                  'Soy lecithin',
                  'Salt',
                  'Palm oil derivatives',
                ],
                ecoScore: 'D',
                novaGroup: 4,
                nutriScore: 'D',
                ethicsScore: 2.3,
                origins: 'Uncertified Cocoa & Sugar',
                isBoycotted: true,
              );
          return BoycottAnalysisScreen(product: product);
        },
      ),
      GoRoute(
        path: RouteNames.alternatives,
        name: 'alternatives',
        builder: (context, state) {
          final product = state.extra as Product? ??
              const Product(
                id: '7613035345678',
                barcode: '7613035345678',
                name: 'Nesquik Chocolate Drink Mix',
                brand: 'Nestlé',
                imageUrl:
                    'https://images.openfoodfacts.org/images/products/761/303/534/5678/front_en.4.400.jpg',
                quantity: '400 g',
                ingredientsText:
                    'Sugar, Cocoa powder, Soy lecithin, Salt, Artificial flavour, Palm oil derivatives',
                ecoScore: 'D',
                novaGroup: 4,
                nutriScore: 'D',
                ethicsScore: 2.3,
                isBoycotted: true,
              );
          return AlternativesScreen(product: product);
        },
      ),
    ],
    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${state.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(RouteNames.scanner),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Navigation Example
// context.push(RoutesNames.login);
