import '../loaders/custom_loader.dart';
import 'package:flutter/material.dart';
import '../more/custom_image_widget.dart';
import '../../extensions/widget_extensions.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/responsive_extension.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? icon;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double? borderRadius;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.borderColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.iconColor,
    this.textStyle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? context.colorScheme.primary,
          side: BorderSide(color: borderColor ?? context.colorScheme.primary),
          shape: borderRadius != null
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius!),
                )
              : null,
        ),
        child: isLoading
            ? CustomLoader(
                color: foregroundColor ?? context.colorScheme.primary,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    CustomImage(image: icon!, color: iconColor),
                    5.wt,
                  ],
                  Text(
                    text,
                    style:
                        textStyle ??
                        context.textTheme.titleMedium?.copyWith(
                          color: foregroundColor ?? context.colorScheme.primary,
                        ),
                  ).flexible(),
                ],
              ),
      ),
    );
  }
}
