import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';

class ScanBottomSheet extends StatelessWidget {
  final bool isTorchOn;
  final VoidCallback onToggleTorch;
  final VoidCallback onCancel;
  final Function(String barcode)? onQuickScan;

  const ScanBottomSheet({
    super.key,
    required this.isTorchOn,
    required this.onToggleTorch,
    required this.onCancel,
    this.onQuickScan,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 14.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Instruction Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.center_focus_strong_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
              8.wt,
              Flexible(
                child: Text(
                  'Align barcode within the frame to scan...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
            ],
          ),

          16.ht,

          // Quick Action Buttons: Flashlight & Cancel
          Row(
            children: [
              // Flashlight toggle
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onToggleTorch,
                  icon: Icon(
                    isTorchOn
                        ? Icons.flashlight_on_rounded
                        : Icons.flashlight_off_rounded,
                    color: isTorchOn ? AppColors.primary : (isDark ? Colors.white70 : Colors.black54),
                    size: 20.sp,
                  ),
                  label: Text(
                    isTorchOn ? 'Flash On' : 'Flashlight',
                    style: TextStyle(
                      color: isTorchOn ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(
                      color: isTorchOn
                          ? AppColors.primary
                          : (isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                    backgroundColor: isTorchOn
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              12.wt,

              // Cancel button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCancel,
                  icon: Icon(Icons.close_rounded, size: 20.sp),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEEEEEE),
                    foregroundColor: isDark ? AppColors.darkText : AppColors.lightText,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),

          14.ht,

          // Instant Test Barcodes for emulator / quick verification
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  'Quick Demo:',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.wt,
                _DemoChip(
                  label: '🥛 Oatly Barista',
                  barcode: '7394376616030',
                  onTap: () => onQuickScan?.call('7394376616030'),
                ),
                6.wt,
                _DemoChip(
                  label: '🍫 Nesquik (Boycott)',
                  barcode: '7613035345678',
                  onTap: () => onQuickScan?.call('7613035345678'),
                  isAlert: true,
                ),
                6.wt,
                _DemoChip(
                  label: '🥤 Coca-Cola',
                  barcode: '5449000000996',
                  onTap: () => onQuickScan?.call('5449000000996'),
                  isAlert: true,
                ),
                6.wt,
                _DemoChip(
                  label: '🍵 Clipper Organic Tea',
                  barcode: '5010029000100',
                  onTap: () => onQuickScan?.call('5010029000100'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoChip extends StatelessWidget {
  final String label;
  final String barcode;
  final VoidCallback onTap;
  final bool isAlert;

  const _DemoChip({
    required this.label,
    required this.barcode,
    required this.onTap,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isAlert
              ? AppColors.boycott.withValues(alpha: 0.12)
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isAlert
                ? AppColors.boycott.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isAlert ? AppColors.boycott : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
