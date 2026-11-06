import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';

class BoycottAlertBanner extends StatelessWidget {
  final bool isFlagged;
  final String message;

  const BoycottAlertBanner({
    super.key,
    required this.isFlagged,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isFlagged ? AppColors.boycott : AppColors.safe;
    final icon = isFlagged ? Icons.warning_amber_rounded : Icons.verified_rounded;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          12.wt,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFlagged
                      ? 'ALERT: ETHICAL CONCERN FOUND'
                      : 'SAFE: VERIFIED ETHICAL STATUS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.sp,
                    letterSpacing: 0.5,
                  ),
                ),
                4.ht,
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 12.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
