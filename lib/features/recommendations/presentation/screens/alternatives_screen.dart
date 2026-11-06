import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/widgets/buttons/app_back_button.dart';
import '../../../../core/widgets/loaders/custom_loader.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../../domain/entities/alternative_product.dart';
import '../providers/recommendations_provider.dart';
import '../widgets/alternative_product_card.dart';
import '../widgets/comparison_modal.dart';

class AlternativesScreen extends StatefulWidget {
  final Product product;

  const AlternativesScreen({
    super.key,
    required this.product,
  });

  @override
  State<AlternativesScreen> createState() => _AlternativesScreenState();
}

class _AlternativesScreenState extends State<AlternativesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecommendationsProvider>().loadAlternatives(widget.product);
    });
  }

  void _showComparison(AlternativeProduct alternative) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ComparisonModal(
        originalProduct: widget.product,
        alternative: alternative,
      ),
    );
  }

  void _showDetailsDialog(AlternativeProduct alternative) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.verified_rounded, color: AppColors.safe),
            8.wt,
            Expanded(
              child: Text(
                alternative.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Brand: ${alternative.brand}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 14.sp,
              ),
            ),
            8.ht,
            Text(
              alternative.description,
              style: TextStyle(fontSize: 13.sp, height: 1.4),
            ),
            12.ht,
            Text(
              'Certifications: ${alternative.certifications}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
            8.ht,
            Text(
              'Carbon Footprint Reduction: ${alternative.carbonFootprintReduction.toStringAsFixed(0)}% vs conventional items',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.safe,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showComparison(alternative);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Compare'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recProvider = context.watch<RecommendationsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Ethical Alternatives',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: recProvider.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomLoader(color: AppColors.primary),
                  12.ht,
                  const Text('Finding certified ethical alternatives...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original Product Summary Card
                  _buildOriginalProductSummaryCard(isDark),

                  20.ht,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended Ethical Upgrades',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.safeLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${recProvider.alternatives.length} verified',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.safe,
                          ),
                        ),
                      ),
                    ],
                  ),

                  12.ht,

                  // List of Alternative Product Cards
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recProvider.alternatives.length,
                    itemBuilder: (context, index) {
                      final alt = recProvider.alternatives[index];
                      return AlternativeProductCard(
                        alternative: alt,
                        onViewDetails: () => _showDetailsDialog(alt),
                        onCompare: () => _showComparison(alt),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOriginalProductSummaryCard(bool isDark) {
    final issues = <String>[];
    if (widget.product.isBoycotted) {
      issues.add('Flagged on Corporate Boycott Watchlists');
    }
    if (widget.product.novaGroup == 4) {
      issues.add('Ultra-Processed NOVA Group 4 Food');
    }
    if (widget.product.ecoScore == 'D' || widget.product.ecoScore == 'E') {
      issues.add('High Carbon Footprint & Packaging Waste');
    }
    if (issues.isEmpty) {
      issues.add('Conventional Supply Chain / Additives Present');
    }

    final score = widget.product.ethicsScore;
    final scoreColor = score >= 7
        ? AppColors.safe
        : score >= 4
            ? AppColors.warning
            : AppColors.boycott;

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
              Text(
                'SCANNED ORIGINAL PRODUCT',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              // Ethics Score (e.g., 4/10)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: scoreColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Ethics Score: ${score.toStringAsFixed(1)}/10',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: scoreColor,
                  ),
                ),
              ),
            ],
          ),

          12.ht,

          Row(
            children: [
              Container(
                width: 55.w,
                height: 55.h,
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.product.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.fastfood, color: Colors.grey),
                        )
                      : const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
              12.wt,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    2.ht,
                    Text(
                      widget.product.brand,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          12.ht,
          const Divider(height: 1),
          10.ht,

          Text(
            'Flagged Issues:',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ),
          6.ht,
          Column(
            children: issues.map((issue) {
              return Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_rounded,
                      size: 14.sp,
                      color: AppColors.boycott,
                    ),
                    6.wt,
                    Expanded(
                      child: Text(
                        issue,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
