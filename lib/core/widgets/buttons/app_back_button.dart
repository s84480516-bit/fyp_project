import 'custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onBackPressed, this.size});
  final VoidCallback? onBackPressed;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onPressed: onBackPressed ?? () => context.pop(),
      icon: Icons.arrow_back_ios_new_rounded,
      size: size,
    );
  }
}