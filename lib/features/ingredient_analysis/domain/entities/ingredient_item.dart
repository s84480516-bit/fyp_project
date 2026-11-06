enum IngredientSafetyStatus {
  safe, // 🟢 Safe / Approved: #2E7D32
  attention, // 🟠 Requires Attention / Warning: #FFA000
  harmful, // 🔴 Boycott / Harmful: #D32F2F
}

class IngredientItem {
  final String name;
  final IngredientSafetyStatus status;
  final String explanation;
  final String riskCategory;
  final String safetyBadgeText;
  final bool isOrganic;
  final bool isVegan;
  final bool isPalmOilFree;

  const IngredientItem({
    required this.name,
    required this.status,
    required this.explanation,
    required this.riskCategory,
    required this.safetyBadgeText,
    this.isOrganic = true,
    this.isVegan = true,
    this.isPalmOilFree = true,
  });

  bool get isSafe => status == IngredientSafetyStatus.safe;
  bool get requiresAttention => status == IngredientSafetyStatus.attention;
  bool get isHarmful => status == IngredientSafetyStatus.harmful;
}
