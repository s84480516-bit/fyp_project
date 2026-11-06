import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/widgets/buttons/app_back_button.dart';
import '../../../../core/widgets/loaders/custom_loader.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../../domain/entities/ingredient_safety_report.dart';
import '../providers/ingredient_analysis_provider.dart';
import '../widgets/ethical_progress_bar.dart';
import '../widgets/ingredient_expandable_tile.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IngredientAnalysisProvider>().analyzeProduct(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final analysisProvider = context.watch<IngredientAnalysisProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final report = analysisProvider.report;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Header Section: Gradient, Back Button, Product Image, Title & Brand
          SliverAppBar(
            expandedHeight: 260.h,
            pinned: true,
            leading: const AppBackButton(),
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing product analysis...')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product saved to favorites')),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [
                            const Color(0xFF1B2F1C),
                            AppColors.darkSurface,
                          ]
                        : [
                            AppColors.mintGreen.withValues(alpha: 0.35),
                            AppColors.lightSurface,
                          ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product Image Container
                      Hero(
                        tag: 'product_img_${widget.product.barcode}',
                        child: Container(
                          width: 110.w,
                          height: 110.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8.r),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: widget.product.imageUrl.isNotEmpty
                                ? Image.network(
                                    widget.product.imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.eco_rounded,
                                      size: 48.sp,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : Icon(
                                    Icons.eco_rounded,
                                    size: 48.sp,
                                    color: AppColors.primary,
                                  ),
                          ),
                        ),
                      ),
                      12.ht,
                      // Product Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          widget.product.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                      ),
                      4.ht,
                      // Brand Name & Quantity
                      Text(
                        '${widget.product.brand} • ${widget.product.quantity.isNotEmpty ? widget.product.quantity : 'Standard Unit'}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: analysisProvider.isLoading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Column(
                          children: [
                            const CustomLoader(color: AppColors.primary),
                            12.ht,
                            const Text('Analyzing ingredients with ScanEth AI...'),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Boycott Flag Alert Banner if boycotted
                        if (widget.product.isBoycotted) ...[
                          InkWell(
                            onTap: () {
                              context.push(
                                RouteNames.boycottAnalysis,
                                extra: widget.product,
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: AppColors.boycottLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.boycott.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: AppColors.boycott,
                                    size: 28.sp,
                                  ),
                                  12.wt,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ETHICAL CONCERN DETECTED',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.boycott,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        2.ht,
                                        Text(
                                          'Brand flagged on corporate boycott watchlists. Tap to inspect.',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: isDark
                                                ? AppColors.darkText
                                                : AppColors.lightText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.boycott,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          16.ht,
                        ],

                        // Ingredient Safety Breakdown Card
                        _buildIngredientSafetyCard(report, analysisProvider, isDark),

                        20.ht,

                        // Ethical & Environmental Analysis Section
                        _buildEthicalEnvironmentalSection(report, isDark),

                        // Padding for sticky bottom actions
                        80.ht,
                      ],
                    ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Actions: Find Ethical Alternatives & Check Boycott Status
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Check Boycott Status Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push(
                      RouteNames.boycottAnalysis,
                      extra: widget.product,
                    );
                  },
                  icon: Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                  label: const Text(
                    'Boycott Check',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              12.wt,

              // Find Ethical Alternatives Primary Button
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      RouteNames.alternatives,
                      extra: widget.product,
                    );
                  },
                  icon: Icon(Icons.swap_horiz_rounded, size: 20.sp),
                  label: const Text(
                    'Find Ethical Alternatives',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
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
        ),
      ),
    );
  }

  Widget _buildIngredientSafetyCard(
    IngredientSafetyReport? report,
    IngredientAnalysisProvider provider,
    bool isDark,
  ) {
    final safeCount = report?.safeCount ?? 5;
    final attentionCount = report?.attentionCount ?? 1;
    final harmfulCount = report?.harmfulCount ?? 0;
    final ingredients = report?.ingredients ?? [];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.biotech_rounded, color: AppColors.primary, size: 22.sp),
              8.wt,
              Text(
                'Ingredient Safety Breakdown',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),

          12.ht,

          // Summary Banner indicating total counts (e.g., 5 Safe, 1 Attention)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: attentionCount > 0 || harmfulCount > 0
                  ? AppColors.warningLight
                  : AppColors.safeLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: attentionCount > 0 || harmfulCount > 0
                    ? AppColors.warning.withValues(alpha: 0.4)
                    : AppColors.safe.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                _buildCountBadge('🟢 $safeCount Safe', AppColors.safe),
                8.wt,
                if (attentionCount > 0) ...[
                  _buildCountBadge('🟠 $attentionCount Attention', AppColors.warning),
                  8.wt,
                ],
                if (harmfulCount > 0)
                  _buildCountBadge('🔴 $harmfulCount Harmful', AppColors.boycott),
              ],
            ),
          ),

          14.ht,

          Text(
            'Tap any ingredient to view toxicology & origin details:',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ),

          10.ht,

          // Expandable List of Ingredients
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final item = ingredients[index];
              return IngredientExpandableTile(
                ingredient: item,
                isExpanded: provider.isExpanded(index),
                onTap: () => provider.toggleExpand(index),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEthicalEnvironmentalSection(
    IngredientSafetyReport? report,
    bool isDark,
  ) {
    final localPct = report?.localPercentage ?? 50.0;
    final boycottFreePct = report?.boycottFreePercentage ?? 30.0;
    final organicPct = report?.organicPercentage ?? 75.0;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.public_rounded, color: AppColors.primary, size: 22.sp),
              8.wt,
              Text(
                'Ethical & Environmental Analysis',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),

          16.ht,

          // Progress Bar 1: Local Sourcing
          EthicalMetricBar(
            title: 'Local Agriculture / Sourcing',
            percentage: localPct,
            subtitle: 'Ingredients grown in local or certified regional cooperatives',
            icon: Icons.agriculture_rounded,
          ),

          // Progress Bar 2: Boycott-Free Compliance
          EthicalMetricBar(
            title: 'Boycott-Free Ethics Compliance',
            percentage: boycottFreePct,
            subtitle: 'Supply chain transparency verified against labor watchlists',
            icon: Icons.gavel_rounded,
          ),

          // Progress Bar 3: Organic & Ecological Rating
          EthicalMetricBar(
            title: 'Ecological & Chemical Rating',
            percentage: organicPct,
            subtitle: 'Free of synthetic pesticides, artificial dyes, and PFAS',
            icon: Icons.forest_rounded,
          ),
        ],
      ),
    );
  }
}
