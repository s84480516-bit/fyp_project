import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../domain/entities/ingredient_item.dart';

class IngredientExpandableTile extends StatelessWidget {
  final IngredientItem ingredient;
  final bool isExpanded;
  final VoidCallback onTap;

  const IngredientExpandableTile({
    super.key,
    required this.ingredient,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badgeColor = ingredient.isHarmful
        ? AppColors.boycott
        : ingredient.requiresAttention
            ? AppColors.warning
            : AppColors.safe;

    final badgeBgColor = ingredient.isHarmful
        ? AppColors.boycottLight
        : ingredient.requiresAttention
            ? AppColors.warningLight
            : AppColors.safeLight;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242424) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded
              ? badgeColor.withValues(alpha: 0.6)
              : (isDark ? AppColors.darkBorder : AppColors.border),
          width: isExpanded ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  // Status Icon Dot
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  12.wt,

                  // Ingredient Name
                  Expanded(
                    child: Text(
                      ingredient.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                  ),

                  // Badge Text
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ingredient.safetyBadgeText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),

                  8.wt,

                  // Expand Chevron
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Details Section
          if (isExpanded)
            Container(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  10.ht,
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16.sp,
                        color: badgeColor,
                      ),
                      6.wt,
                      Text(
                        'Category: ${ingredient.riskCategory}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: badgeColor,
                        ),
                      ),
                    ],
                  ),
                  8.ht,
                  Text(
                    ingredient.explanation,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.4,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  12.ht,
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: [
                      if (ingredient.isOrganic)
                        _TagChip(label: '🌱 Organic Compliant', color: AppColors.safe),
                      if (ingredient.isVegan)
                        _TagChip(label: '🌿 100% Vegan', color: AppColors.safe),
                      if (ingredient.isPalmOilFree)
                        _TagChip(label: '🌴 Palm Oil-Free', color: AppColors.safe)
                      else
                        _TagChip(label: '⚠️ Contains Palm Oil', color: AppColors.boycott),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
