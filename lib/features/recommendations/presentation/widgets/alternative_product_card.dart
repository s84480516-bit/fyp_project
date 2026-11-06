import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../domain/entities/alternative_product.dart';

class AlternativeProductCard extends StatelessWidget {
  final AlternativeProduct alternative;
  final VoidCallback onViewDetails;
  final VoidCallback onCompare;

  const AlternativeProductCard({
    super.key,
    required this.alternative,
    required this.onViewDetails,
    required this.onCompare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Image, Title, Brand & Ethics Score Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 72.w,
                height: 72.h,
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: alternative.imageUrl.isNotEmpty
                      ? Image.network(
                          alternative.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.eco_rounded,
                                color: AppColors.primary,
                              ),
                        )
                      : const Icon(
                          Icons.eco_rounded,
                          color: AppColors.primary,
                        ),
                ),
              ),

              14.wt,

              // Title & Brand
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alternative.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    4.ht,
                    Text(
                      alternative.brand,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              8.wt,

              // Ethics Score Badge (e.g. 9.7/10)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.safeLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.safe.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      alternative.ethicsScore.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.safe,
                      ),
                    ),
                    Text(
                      '/10',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.safe,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          12.ht,

          // Local Organic Description
          Text(
            alternative.description,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.4,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ),

          12.ht,

          // Comparison Metric Banner (e.g., Lower Sugar Content (-40% vs. original))
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_down_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                8.wt,
                Expanded(
                  child: Text(
                    alternative.comparisonMetric,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          12.ht,

          // Tag Badges: 🟢 Boycott-Free, 🟢 Sustainable Sourcing, No Palm Oil, Vegan, Cruelty-Free
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: alternative.tagBadges.map((badge) {
              final isGreen = badge.contains('🟢') || badge.contains('Boycott') || badge.contains('Sustainable');
              final badgeColor = isGreen ? AppColors.safe : (isDark ? AppColors.darkSubText : AppColors.lightSubText);

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isGreen ? AppColors.safeLight : (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F0F0)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isGreen ? AppColors.safe.withValues(alpha: 0.25) : Colors.transparent,
                  ),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
              );
            }).toList(),
          ),

          16.ht,

          // Action Buttons: View Details & Compare
          Row(
            children: [
              // Compare Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCompare,
                  icon: Icon(Icons.compare_arrows_rounded, size: 18.sp, color: AppColors.primary),
                  label: const Text(
                    'Compare',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              12.wt,

              // View Details Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onViewDetails,
                  icon: Icon(Icons.visibility_outlined, size: 18.sp),
                  label: const Text(
                    'View Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
