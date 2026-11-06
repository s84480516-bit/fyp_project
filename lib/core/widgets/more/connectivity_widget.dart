import '../../enums/app_enums.dart';
import 'package:flutter/material.dart';
import '../animated/animated_button.dart';
import '../../constants/app_constants.dart';
import '../../extensions/widget_extensions.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/responsive_extension.dart';
import '../../services/network/network_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cleanarchitecturetemplate/core/widgets/snackbars/custom_snackbars.dart';

/// Reusable connectivity checker widget with offline screen
class ConnectivityWidget extends StatelessWidget {
  final Widget child;
  final Widget? offlineWidget;

  const ConnectivityWidget({
    super.key,
    required this.child,
    this.offlineWidget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: NetworkService().connectionStream,
      initialData: const [ConnectivityResult.none],
      builder: (context, snapshot) {
        final results = snapshot.data ?? [ConnectivityResult.none];
        final isConnected =
            results.isNotEmpty && !results.contains(ConnectivityResult.none);

        if (!isConnected) {
          return offlineWidget ?? const OfflineScreen();
        }

        return child;
      },
    );
  }
}

/// Default offline screen with modern design
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (value * 0.2),
                child:
                    SizedBox(
                          width: 120.w,
                          height: 120.w,
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: 60.sp,
                            color: context.colorScheme.error,
                          ),
                        )
                        .opacity(value)
                        .decorated(
                          color: context.colorScheme.errorContainer.withValues(
                            alpha: 0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
              );
            },
          ),

          32.ht,

          // Title
          Text(
            'No Internet Connection',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          16.ht,

          // Description
          Text(
            'Please check your connection and try again. Make sure WiFi or cellular data is turned on.',
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),

          40.ht,

          // Retry button with animation
          AnimatedButton(
            onPressed: () async {
              final results = await Connectivity().checkConnectivity();
              final isConnected =
                  results.isNotEmpty &&
                  !results.contains(ConnectivityResult.none);

              if (isConnected) {
                if (context.mounted) {
                  CustomSnackbar.show(
                    context: context,
                    message: 'Connection restored!',
                    type: SnackbarType.success,
                  );
                }
              }
            },
            fitToContent: true,
            icon: Icons.refresh_rounded,
            text: 'Retry Connection',
          ),
        ],
      ).paddingSymmetric(horizontal: AppConstants.hPadding),
    );
  }
}
