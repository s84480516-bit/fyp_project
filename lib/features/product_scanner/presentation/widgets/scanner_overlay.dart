import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ScannerOverlay extends StatefulWidget {
  final double scanWindowWidth;
  final double scanWindowHeight;
  final double borderRadius;

  const ScannerOverlay({
    super.key,
    this.scanWindowWidth = 270,
    this.scanWindowHeight = 270,
    this.borderRadius = 24,
  });

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _laserAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        final left = (screenWidth - widget.scanWindowWidth) / 2;
        final top = (screenHeight - widget.scanWindowHeight) / 2.3;
        final scanRect = Rect.fromLTWH(
          left,
          top,
          widget.scanWindowWidth,
          widget.scanWindowHeight,
        );

        return Stack(
          children: [
            // Darkened viewfinder backdrop with cutout
            CustomPaint(
              size: Size(screenWidth, screenHeight),
              painter: _ViewfinderHolePainter(
                scanRect: scanRect,
                borderRadius: widget.borderRadius,
              ),
            ),

            // Rounded Green Bounding Frame & Corner Accents
            Positioned(
              left: scanRect.left,
              top: scanRect.top,
              width: scanRect.width,
              height: scanRect.height,
              child: CustomPaint(
                painter: _BoundingFramePainter(
                  borderColor: AppColors.primary,
                  cornerColor: AppColors.secondary,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),

            // Animated Scanning Laser Line
            AnimatedBuilder(
              animation: _laserAnimation,
              builder: (context, child) {
                final laserTop =
                    scanRect.top +
                    (scanRect.height - 12) * _laserAnimation.value;

                return Positioned(
                  left: scanRect.left + 10,
                  top: laserTop,
                  width: scanRect.width - 20,
                  child: Container(
                    height: 3.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.secondary,
                          Colors.white,
                          AppColors.secondary,
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.8),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ViewfinderHolePainter extends CustomPainter {
  final Rect scanRect;
  final double borderRadius;

  _ViewfinderHolePainter({
    required this.scanRect,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holeRRect = RRect.fromRectAndRadius(
      scanRect,
      Radius.circular(borderRadius),
    );
    final holePath = Path()..addRRect(holeRRect);

    final combinedPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      holePath,
    );

    canvas.drawPath(combinedPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant _ViewfinderHolePainter oldDelegate) =>
      oldDelegate.scanRect != scanRect;
}

class _BoundingFramePainter extends CustomPainter {
  final Color borderColor;
  final Color cornerColor;
  final double borderRadius;

  _BoundingFramePainter({
    required this.borderColor,
    required this.cornerColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle outer frame
    final framePaint = Paint()
      ..color = borderColor.withValues(alpha: 0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(rrect, framePaint);

    // Thick rounded corner accents
    final cornerPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const cornerLength = 34.0;

    // Top-Left corner
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, borderRadius)
        ..quadraticBezierTo(0, 0, borderRadius, 0)
        ..lineTo(cornerLength, 0),
      cornerPaint,
    );

    // Top-Right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width - borderRadius, 0)
        ..quadraticBezierTo(size.width, 0, size.width, borderRadius)
        ..lineTo(size.width, cornerLength),
      cornerPaint,
    );

    // Bottom-Left corner
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height - borderRadius)
        ..quadraticBezierTo(0, size.height, borderRadius, size.height)
        ..lineTo(cornerLength, size.height),
      cornerPaint,
    );

    // Bottom-Right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width - borderRadius, size.height)
        ..quadraticBezierTo(size.width, size.height, size.width, size.height - borderRadius)
        ..lineTo(size.width, size.height - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BoundingFramePainter oldDelegate) => false;
}
