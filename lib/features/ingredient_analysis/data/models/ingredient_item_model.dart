import '../../domain/entities/ingredient_item.dart';

class IngredientItemModel extends IngredientItem {
  const IngredientItemModel({
    required super.name,
    required super.status,
    required super.explanation,
    required super.riskCategory,
    required super.safetyBadgeText,
    super.isOrganic,
    super.isVegan,
    super.isPalmOilFree,
  });

  factory IngredientItemModel.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status']?.toString().toLowerCase() ?? 'safe';
    final status = statusStr == 'harmful'
        ? IngredientSafetyStatus.harmful
        : statusStr == 'attention' || statusStr == 'warning'
            ? IngredientSafetyStatus.attention
            : IngredientSafetyStatus.safe;

    return IngredientItemModel(
      name: json['name']?.toString() ?? 'Ingredient',
      status: status,
      explanation: json['explanation']?.toString() ?? 'Natural food ingredient analyzed for dietary and ethical impact.',
      riskCategory: json['riskCategory']?.toString() ?? 'Dietary Component',
      safetyBadgeText: json['safetyBadgeText']?.toString() ?? (status == IngredientSafetyStatus.safe ? 'Safe' : 'Requires Attention'),
      isOrganic: json['isOrganic'] ?? true,
      isVegan: json['isVegan'] ?? true,
      isPalmOilFree: json['isPalmOilFree'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status.name,
      'explanation': explanation,
      'riskCategory': riskCategory,
      'safetyBadgeText': safetyBadgeText,
      'isOrganic': isOrganic,
      'isVegan': isVegan,
      'isPalmOilFree': isPalmOilFree,
    };
  }
}
