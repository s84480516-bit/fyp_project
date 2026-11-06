import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cleanarchitecturetemplate/core/config/responsive_config.dart';
import 'package:cleanarchitecturetemplate/features/boycott_check/presentation/widgets/boycott_alert_banner.dart';
import 'package:cleanarchitecturetemplate/features/ingredient_analysis/domain/entities/ingredient_item.dart';
import 'package:cleanarchitecturetemplate/features/ingredient_analysis/presentation/widgets/ethical_progress_bar.dart';
import 'package:cleanarchitecturetemplate/features/ingredient_analysis/presentation/widgets/ingredient_expandable_tile.dart';
import 'package:cleanarchitecturetemplate/features/recommendations/domain/entities/alternative_product.dart';
import 'package:cleanarchitecturetemplate/features/recommendations/presentation/widgets/alternative_product_card.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/presentation/widgets/scanner_overlay.dart';

Widget wrapWithResponsive(Widget child) {
  return ResponsiveProvider(
    mobileSize: const Size(360, 800),
    tabletSize: const Size(800, 1280),
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  testWidgets('ScannerOverlay renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrapWithResponsive(const ScannerOverlay(scanWindowWidth: 200, scanWindowHeight: 200)),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ScannerOverlay), findsOneWidget);
  });

  testWidgets('BoycottAlertBanner displays flagged alert correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrapWithResponsive(
        const BoycottAlertBanner(
          isFlagged: true,
          message: 'Flagged on Corporate Boycott Watchlists.',
        ),
      ),
    );

    expect(find.text('ALERT: ETHICAL CONCERN FOUND'), findsOneWidget);
    expect(find.text('Flagged on Corporate Boycott Watchlists.'), findsOneWidget);
  });

  testWidgets('EthicalMetricBar displays title and percentage', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrapWithResponsive(
        const EthicalMetricBar(
          title: 'Local Agriculture',
          percentage: 65.0,
          subtitle: 'Grown within regional cooperative',
          icon: Icons.agriculture_rounded,
        ),
      ),
    );

    expect(find.text('Local Agriculture'), findsOneWidget);
    expect(find.text('65%'), findsOneWidget);
    expect(find.text('Grown within regional cooperative'), findsOneWidget);
  });

  testWidgets('IngredientExpandableTile expands and shows details when tapped', (WidgetTester tester) async {
    bool tapped = false;
    const ingredient = IngredientItem(
      name: 'Rapeseed Oil',
      status: IngredientSafetyStatus.attention,
      explanation: 'Refined vegetable seed oil.',
      riskCategory: 'Vegetable Oil',
      safetyBadgeText: 'Requires Attention',
    );

    await tester.pumpWidget(
      wrapWithResponsive(
        IngredientExpandableTile(
          ingredient: ingredient,
          isExpanded: false,
          onTap: () {
            tapped = true;
          },
        ),
      ),
    );

    expect(find.text('Rapeseed Oil'), findsOneWidget);
    expect(find.text('Requires Attention'), findsOneWidget);

    await tester.tap(find.text('Rapeseed Oil'));
    expect(tapped, isTrue);
  });

  testWidgets('AlternativeProductCard renders tags and triggers callbacks', (WidgetTester tester) async {
    bool detailsTapped = false;
    bool compareTapped = false;

    const alt = AlternativeProduct(
      id: 'alt_1',
      name: 'Minor Figures Oat Drink',
      brand: 'Minor Figures',
      imageUrl: '',
      ethicsScore: 9.6,
      description: 'Certified 100% organic oat m*lk.',
      tagBadges: ['🟢 Boycott-Free', '🟢 Sustainable Sourcing', 'Vegan'],
      comparisonMetric: 'Lower Sugar Content (-40% vs. original)',
    );

    await tester.pumpWidget(
      wrapWithResponsive(
        AlternativeProductCard(
          alternative: alt,
          onViewDetails: () {
            detailsTapped = true;
          },
          onCompare: () {
            compareTapped = true;
          },
        ),
      ),
    );

    expect(find.text('Minor Figures Oat Drink'), findsOneWidget);
    expect(find.text('Minor Figures'), findsOneWidget);
    expect(find.text('9.6'), findsOneWidget);
    expect(find.text('🟢 Boycott-Free'), findsOneWidget);
    expect(find.text('Lower Sugar Content (-40% vs. original)'), findsOneWidget);

    await tester.tap(find.text('View Details'));
    expect(detailsTapped, isTrue);

    await tester.tap(find.text('Compare'));
    expect(compareTapped, isTrue);
  });
}
