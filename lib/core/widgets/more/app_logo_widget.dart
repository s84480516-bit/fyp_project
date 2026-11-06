import '../../constants/app_assets.dart';
import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key, this.height = 165, this.width = 165});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.logo, width: width, height: height);
  }
}

class AppLogoWhiteWidget extends StatelessWidget {
  const AppLogoWhiteWidget({super.key, this.height = 165, this.width = 165});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset('AppAssets.logoWhite', width: width, height: height);
  }
}
