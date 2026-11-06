import 'ingredient_item.dart';

class IngredientSafetyReport {
  final String productId;
  final int totalCount;
  final int safeCount;
  final int attentionCount;
  final int harmfulCount;
  final List<IngredientItem> ingredients;
  final double localPercentage; // e.g. 50.0 (50%)
  final double boycottFreePercentage; // e.g. 30.0 (30%)
  final double organicPercentage;
  final String summaryHeadline;

  const IngredientSafetyReport({
    required this.productId,
    required this.totalCount,
    required this.safeCount,
    required this.attentionCount,
    required this.harmfulCount,
    required this.ingredients,
    required this.localPercentage,
    required this.boycottFreePercentage,
    this.organicPercentage = 75.0,
    required this.summaryHeadline,
  });

  String get countSummary => '$safeCount Safe, $attentionCount Attention';
}
