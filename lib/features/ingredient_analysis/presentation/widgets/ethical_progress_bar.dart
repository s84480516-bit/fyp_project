import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';

class EthicalMetricBar extends StatelessWidget {
  final String title;
  final double percentage;
  final String subtitle;
  final IconData icon;
  final Color? barColor;

  const EthicalMetricBar({
    super.key,
    required this.title,
    required this.percentage,
    required this.subtitle,
    required this.icon,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color effectiveColor = barColor ??
        (percentage >= 70
            ? AppColors.safe
            : percentage >= 40
                ? AppColors.warning
                : AppColors.boycott);

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: effectiveColor),
              6.wt,
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const Spacer(),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: effectiveColor,
                ),
              ),
            ],
          ),
          6.ht,
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (percentage / 100.0).clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: isDark ? const Color(0xFF333333) : const Color(0xFFE5E5E5),
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            ),
          ),
          4.ht,
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ),
        ],
      ),
    );
  }
}
