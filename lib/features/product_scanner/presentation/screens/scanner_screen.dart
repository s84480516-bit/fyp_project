import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/widgets/inputs/search_field.dart';
import '../../../../core/widgets/loaders/custom_loader.dart';
import '../providers/scanner_provider.dart';
import '../widgets/scan_bottom_sheet.dart';
import '../widgets/scanner_overlay.dart';
import '../../domain/entities/product.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannerProvider>().initScanner();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onProductScanned(Product product) {
    context.push(RouteNames.productDetails, extra: product);
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = context.watch<ScannerProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(125.h),
        child: Container(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            right: 16.w,
            bottom: 12.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Branding Row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.eco_rounded,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                  10.wt,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ScanEth',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                              letterSpacing: -0.5,
                            ),
                          ),
                          4.wt,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'AI',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Ethical Consumer Intelligence',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Eco Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.safeLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.safe,
                            shape: BoxShape.circle,
                          ),
                        ),
                        6.wt,
                        Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              10.ht,

              // Integrated Search Bar
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF282828) : const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SearchTextField(
                  controller: _searchController,
                  hint: 'Search product by name or brand...',
                  onChanged: (val) {
                    scannerProvider.searchProducts(val);
                  },
                  onClear: () {
                    _searchController.clear();
                    scannerProvider.clearSearch();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // If Search is active and has results, display Search Results List
          if (scannerProvider.searchResults.isNotEmpty || scannerProvider.isSearching)
            _buildSearchResults(scannerProvider, isDark)
          else if (scannerProvider.selectedNavIndex == 1)
            _buildSearchTabView(scannerProvider, isDark)
          else if (scannerProvider.selectedNavIndex == 2)
            _buildHistoryTabView(scannerProvider, isDark)
          else if (scannerProvider.selectedNavIndex == 3)
            _buildProfileTabView(isDark)
          else
            // Main Scanner Viewfinder Body
            _buildCameraViewfinder(scannerProvider),

          // Loading Indicator Overlay when resolving barcode
          if (scannerProvider.status == ScannerStatus.loading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomLoader(color: AppColors.primary),
                        16.ht,
                        Text(
                          'Analyzing ingredients & ethics...',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: scannerProvider.selectedNavIndex,
        onTap: (index) {
          scannerProvider.setNavIndex(index);
          if (index == 0) {
            scannerProvider.resetScanner();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_rounded),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCameraViewfinder(ScannerProvider provider) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera Feed / Mock Cam Background
        MobileScanner(
          controller: provider.scannerController,
          onDetect: (capture) {
            final barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final rawValue = barcode.rawValue;
              if (rawValue != null && rawValue.isNotEmpty) {
                provider.onBarcodeDetected(rawValue).then((product) {
                  if (product != null && mounted) {
                    _onProductScanned(product);
                  }
                });
                break;
              }
            }
          },
          errorBuilder: (context, error) {
            // Friendly fallback if running on emulator or permissions not granted
            return Container(
              color: const Color(0xFF1E231F),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 48.sp,
                      color: AppColors.secondary,
                    ),
                    12.ht,
                    Text(
                      'Live Camera Ready',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    6.ht,
                    Text(
                      'Use demo chips below or scan with device camera',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Rounded Green Bounding Frame & Laser Scanner Overlay
        const ScannerOverlay(
          scanWindowWidth: 260,
          scanWindowHeight: 260,
          borderRadius: 24,
        ),

        // Bottom Controls Sheet
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ScanBottomSheet(
            isTorchOn: provider.isTorchOn,
            onToggleTorch: () => provider.toggleTorch(),
            onCancel: () {
              provider.resetScanner();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scanner reset'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            onQuickScan: (code) {
              provider.onBarcodeDetected(code).then((product) {
                if (product != null && mounted) {
                  _onProductScanned(product);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(ScannerProvider provider, bool isDark) {
    if (provider.isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoader(color: AppColors.primary),
            12.ht,
            Text(
              'Searching Open Food Facts...',
              style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final product = provider.searchResults[index];
        return _buildProductListTile(product, isDark);
      },
    );
  }

  Widget _buildSearchTabView(ScannerProvider provider, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Ethical Database',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          8.ht,
          Text(
            'Over 3 million products categorized by ingredient safety, boycott compliance, and ecological footprint.',
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ),
          20.ht,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildCategoryChip('🥛 Plant Milks', 'Oat milk', provider),
              _buildCategoryChip('🍫 Fairtrade Cocoa', 'Chocolate', provider),
              _buildCategoryChip('🍵 Organic Teas', 'Tea', provider),
              _buildCategoryChip('🥤 Natural Drinks', 'Juice', provider),
              _buildCategoryChip('🥖 Artisan Breads', 'Sourdough', provider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String title, String query, ScannerProvider provider) {
    return ActionChip(
      label: Text(title),
      onPressed: () {
        _searchController.text = query;
        provider.searchProducts(query);
      },
      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
      side: const BorderSide(color: AppColors.primary, width: 0.8),
    );
  }

  Widget _buildHistoryTabView(ScannerProvider provider, bool isDark) {
    if (provider.recentScans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64.sp, color: Colors.grey),
            12.ht,
            Text(
              'No scan history yet',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            6.ht,
            Text(
              'Your recently scanned products will appear here.',
              style: TextStyle(fontSize: 13.sp, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: provider.recentScans.length,
      itemBuilder: (context, index) {
        final product = provider.recentScans[index];
        return _buildProductListTile(product, isDark);
      },
    );
  }

  Widget _buildProfileTabView(bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.person, color: Colors.white, size: 36),
              ),
              16.wt,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eco Consumer',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  4.ht,
                  Text(
                    'Level 3 Conscious Shopper',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          24.ht,
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(
              children: [
                _buildProfileStatRow('Ethical Scans Completed', '28'),
                const Divider(),
                _buildProfileStatRow('Boycott Products Avoided', '9'),
                const Divider(),
                _buildProfileStatRow('Estimated Carbon Saved', '14.8 kg CO₂'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildProductListTile(Product product, bool isDark) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.r),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50.w,
            height: 50.h,
            color: Colors.grey.shade200,
            child: product.imageUrl.isNotEmpty
                ? Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.fastfood, color: Colors.grey),
                  )
                : const Icon(Icons.fastfood, color: Colors.grey),
          ),
        ),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            4.ht,
            Text(
              product.brand,
              style: TextStyle(fontSize: 12.sp, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
            ),
            6.ht,
            Row(
              children: [
                if (product.isBoycotted)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.boycottLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '🔴 Boycott Flag',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.boycott,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.safeLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '🟢 Safe Brand',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.safe,
                      ),
                    ),
                  ),
                8.wt,
                Text(
                  'Eco: ${product.ecoScore}',
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 24.sp),
        onTap: () => _onProductScanned(product),
      ),
    );
  }
}
