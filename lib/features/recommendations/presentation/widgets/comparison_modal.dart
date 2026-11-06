import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../domain/entities/alternative_product.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';

class ComparisonModal extends StatelessWidget {
  final Product originalProduct;
  final AlternativeProduct alternative;

  const ComparisonModal({
    super.key,
    required this.originalProduct,
    required this.alternative,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Row(
              children: [
                Icon(Icons.compare_arrows_rounded, color: AppColors.primary, size: 24.sp),
                8.wt,
                Text(
                  'Side-by-Side Comparison',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),

            16.ht,

            // Header comparing names
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF282828) : const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'ORIGINAL',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                          ),
                        ),
                        4.ht,
                        Text(
                          originalProduct.name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        2.ht,
                        Text(
                          originalProduct.brand,
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                12.wt,

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.safeLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.safe.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'ETHICAL ALTERNATIVE',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.safe,
                          ),
                        ),
                        4.ht,
                        Text(
                          alternative.name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.safe,
                          ),
                        ),
                        2.ht,
                        Text(
                          alternative.brand,
                          style: TextStyle(fontSize: 11.sp, color: AppColors.safe),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            20.ht,

            _buildComparisonRow(
              metric: 'Ethics Score',
              originalVal: '${originalProduct.ethicsScore}/10',
              altVal: '${alternative.ethicsScore}/10',
              isOriginalBetter: false,
              isDark: isDark,
            ),

            _buildComparisonRow(
              metric: 'Boycott Status',
              originalVal: originalProduct.isBoycotted ? '🔴 Flagged' : '🟢 Clear',
              altVal: '🟢 100% Free',
              isOriginalBetter: false,
              isDark: isDark,
            ),

            _buildComparisonRow(
              metric: 'Palm Oil',
              originalVal: originalProduct.isBoycotted ? '⚠️ Sourced' : 'Trace',
              altVal: '🌱 0% Palm Oil',
              isOriginalBetter: false,
              isDark: isDark,
            ),

            _buildComparisonRow(
              metric: 'Carbon Footprint',
              originalVal: 'Standard High',
              altVal: '${alternative.carbonFootprintReduction.toStringAsFixed(0)}% CO₂',
              isOriginalBetter: false,
              isDark: isDark,
            ),

            _buildComparisonRow(
              metric: 'Certifications',
              originalVal: 'Conventional',
              altVal: alternative.certifications,
              isOriginalBetter: false,
              isDark: isDark,
            ),

            20.ht,

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Close Comparison'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow({
    required String metric,
    required String originalVal,
    required String altVal,
    required bool isOriginalBetter,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Text(
            metric,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ),
          6.ht,
          Row(
            children: [
              Expanded(
                child: Text(
                  originalVal,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_rounded, size: 16.sp, color: AppColors.safe),
              Expanded(
                child: Text(
                  altVal,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.safe,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
