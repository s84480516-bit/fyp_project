import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.color,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isNetwork => image.startsWith('http');
  bool get _isSvg => image.toLowerCase().endsWith('.svg');
  bool get _isAsset => image.startsWith('assets/');
  bool get _isFile => File(image).existsSync();

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return _error();
    }

    /// 🌐 Network SVG
    if (_isNetwork && _isSvg) {
      return SvgPicture.network(
        image,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (_) => _placeholder(),
      );
    }

    /// 🌐 Network Image
    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: image,
        height: height,
        width: width,
        fit: fit,
        placeholder: (_, _) => _placeholder(),
        errorWidget: (_, _, _) => _error(),
      );
    }

    /// 🖼 Asset SVG
    if (_isAsset && _isSvg) {
      return SvgPicture.asset(
        image,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    }

    /// 🖼 Asset Image
    if (_isAsset) {
      return Image.asset(
        image,
        height: height,
        width: width,
        fit: fit,
        color: color,
      );
    }

    /// 📂 File SVG
    if (_isFile && _isSvg) {
      return SvgPicture.file(
        File(image),
        height: height,
        width: width,
        fit: fit,
      );
    }

    /// 📂 File Image
    if (_isFile) {
      return Image.file(File(image), height: height, width: width, fit: fit);
    }

    return _error();
  }

  Widget _placeholder() {
    return placeholder ??
        const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }

  Widget _error() {
    return errorWidget ??
        const Icon(Icons.broken_image, size: 40, color: Colors.grey);
  }
}
