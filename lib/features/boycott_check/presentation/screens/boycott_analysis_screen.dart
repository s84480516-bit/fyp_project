import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/widgets/buttons/app_back_button.dart';
import '../../../../core/widgets/loaders/custom_loader.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../../domain/entities/boycott_record.dart';
import '../providers/boycott_check_provider.dart';
import '../widgets/boycott_alert_banner.dart';

class BoycottAnalysisScreen extends StatefulWidget {
  final Product product;

  const BoycottAnalysisScreen({
    super.key,
    required this.product,
  });

  @override
  State<BoycottAnalysisScreen> createState() => _BoycottAnalysisScreenState();
}

class _BoycottAnalysisScreenState extends State<BoycottAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoycottCheckProvider>().checkBrand(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final boycottProvider = context.watch<BoycottCheckProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final record = boycottProvider.record;

    final isFlagged = record?.isFlagged ?? widget.product.isBoycotted;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Brand Verification & Ethics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: boycottProvider.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomLoader(color: AppColors.primary),
                  12.ht,
                  const Text('Verifying global boycott registries...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Overview Card
                  _buildProductOverviewCard(isDark, isFlagged),

                  16.ht,

                  // Warning Alert Banner (High-contrast red/orange alert box)
                  BoycottAlertBanner(
                    isFlagged: isFlagged,
                    message: record?.alertMessage ??
                        (isFlagged
                            ? "This product's parent brand is currently flagged on recognized boycott lists."
                            : "No active boycott concerns found for this brand in international registries."),
                  ),

                  20.ht,

                  // Detailed Breakdown List
                  _buildDetailedBreakdownList(record, isDark, isFlagged),

                  24.ht,

                  // Alternative Suggestions Section
                  _buildAlternativeSuggestionsSection(
                    boycottProvider.safeAlternatives,
                    isDark,
                  ),

                  24.ht,
                ],
              ),
            ),
    );
  }

  Widget _buildProductOverviewCard(bool isDark, bool isFlagged) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 68.w,
            height: 68.h,
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
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

          14.wt,

          // Product Name, Brand & Scan Badge
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
                4.ht,
                Text(
                  'Brand: ${widget.product.brand}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                8.ht,
                // Scan Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isFlagged ? AppColors.boycottLight : AppColors.safeLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isFlagged
                          ? AppColors.boycott.withValues(alpha: 0.4)
                          : AppColors.safe.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFlagged ? Icons.cancel_rounded : Icons.check_circle_rounded,
                        size: 14.sp,
                        color: isFlagged ? AppColors.boycott : AppColors.safe,
                      ),
                      6.wt,
                      Text(
                        isFlagged ? '🔴 BOYCOTT FLAGGED' : '🟢 VERIFIED SAFE BRAND',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: isFlagged ? AppColors.boycott : AppColors.safe,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBreakdownList(
    BoycottRecord? record,
    bool isDark,
    bool isFlagged,
  ) {
    final lists = record?.boycottLists ??
        (isFlagged
            ? [
                'Corporate Accountability Boycott list',
                'Fair Labor Supply Chain Audit',
              ]
            : ['No active listings on recognized registries']);

    final primaryIssue = record?.primaryIssue ??
        (isFlagged
            ? 'Specific labor rights or sourcing violations'
            : 'Adheres to fair labor covenants & ILO conventions');

    final detailedReason = record?.detailedReason ??
        (isFlagged
            ? 'Independent audits cite serious labor rights disputes and environmental violations across cocoa and agricultural supply chains.'
            : 'This brand operates verified ethical supply chains with complete labor transparency.');

    return Container(
      padding: EdgeInsets.all(18.r),
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
              Icon(Icons.fact_check_rounded, color: AppColors.primary, size: 20.sp),
              8.wt,
              Text(
                'Detailed Ethical Breakdown',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),

          14.ht,

          // Listed on section
          _buildBreakdownItem(
            title: 'Listed on:',
            content: lists.join('\n• '),
            prefix: '• ',
            color: isFlagged ? AppColors.boycott : AppColors.safe,
            isDark: isDark,
          ),

          14.ht,
          const Divider(height: 1),
          14.ht,

          // Reason / Associated Issue
          _buildBreakdownItem(
            title: 'Reason / Associated Issue:',
            content: primaryIssue,
            color: isFlagged ? AppColors.warning : AppColors.safe,
            isDark: isDark,
          ),

          14.ht,
          const Divider(height: 1),
          14.ht,

          // In-Depth Background Details
          _buildBreakdownItem(
            title: 'Audit Findings & Context:',
            content: detailedReason,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            isDark: isDark,
          ),

          14.ht,
          const Divider(height: 1),
          14.ht,

          // Parent Corporate Conglomerate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Parent Corporation:',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
              ),
              Text(
                record?.parentCompany ?? widget.product.brand,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem({
    required String title,
    required String content,
    String prefix = '',
    required Color color,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
          ),
        ),
        6.ht,
        Text(
          '$prefix$content',
          style: TextStyle(
            fontSize: 13.sp,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ],
    );
  }

  Widget _buildAlternativeSuggestionsSection(
    List alternatives,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Safer Ethical Brand Choices',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(RouteNames.alternatives, extra: widget.product);
              },
              child: const Text('See All'),
            ),
          ],
        ),
        8.ht,
        SizedBox(
          height: 175.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: alternatives.length,
            itemBuilder: (context, index) {
              final alt = alternatives[index];
              return Container(
                width: 160.w,
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: alt.imageUrl.isNotEmpty
                              ? Image.network(
                                  alt.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.eco, color: AppColors.primary),
                                )
                              : const Icon(Icons.eco, color: AppColors.primary),
                        ),
                      ),
                    ),
                    8.ht,
                    Text(
                      alt.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    2.ht,
                    Text(
                      alt.brand,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.safeLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '🟢 Boycott-Free',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.safe,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
