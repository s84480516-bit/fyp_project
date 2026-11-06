import '../../theme/app_colors.dart';
import '../loaders/custom_loader.dart';
import 'package:flutter/material.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/responsive_extension.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final bool fitToContent;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.textStyle,
    this.fitToContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fitToContent ? null : (width ?? double.infinity),
      height: height ?? 60.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? context.colorScheme.primary,
          foregroundColor: foregroundColor ?? AppColors.white,
          side: const BorderSide(color: AppColors.transparent),
          padding: fitToContent
              ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
              : null,
        ),
        child: isLoading
            ? CustomLoader(color: foregroundColor ?? AppColors.white)
            : Row(
                mainAxisSize: fitToContent
                    ? MainAxisSize.min
                    : MainAxisSize.max,
                children: [
                  /// Left spacer for center alignment
                  if (!fitToContent) const Spacer(),

                  /// Centered Text
                  Text(text, style: textStyle),

                  /// Push icon to the right
                  if (icon != null) ...[
                    10.wt,
                    Icon(
                      icon,
                      color: foregroundColor ?? AppColors.white,
                      size: 20.sp,
                    ),
                  ],

                  /// Right spacer for full width
                  if (!fitToContent) const Spacer(),
                ],
              ),
      ),
    );
  }
}
