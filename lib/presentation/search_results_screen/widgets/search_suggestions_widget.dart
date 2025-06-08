import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final List<String> recentSearches;
  final List<String> trendingTopics;
  final Function(String) onSearchTap;
  final VoidCallback onClearRecentSearches;

  const SearchSuggestionsWidget({
    super.key,
    required this.recentSearches,
    required this.trendingTopics,
    required this.onSearchTap,
    required this.onClearRecentSearches,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches Section
          if (recentSearches.isNotEmpty) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: theme.iconTheme.color!,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Recent Searches',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onClearRecentSearches,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: theme.colorScheme.tertiary,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...recentSearches.map((search) => _buildSearchItem(
                  context: context,
                  text: search,
                  icon: 'history',
                  onTap: () => onSearchTap(search),
                )),
            SizedBox(height: 3.h),
          ],

          // Trending Topics Section
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trending_up',
                color: theme.colorScheme.tertiary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Trending Topics',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Trending topics as chips
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: trendingTopics
                .map((topic) => _buildTrendingChip(
                      context: context,
                      text: topic,
                      onTap: () => onSearchTap(topic),
                    ))
                .toList(),
          ),

          SizedBox(height: 3.h),

          // Search Tips Section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb_outline',
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Search Tips',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildTipItem(
                  context: context,
                  tip: 'Use specific keywords for better results',
                ),
                _buildTipItem(
                  context: context,
                  tip: 'Try searching by source name or category',
                ),
                _buildTipItem(
                  context: context,
                  tip: 'Use filters to narrow down your search',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchItem({
    required BuildContext context,
    required String text,
    required String icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: theme.iconTheme.color!.withValues(alpha: 0.6),
              size: 18,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            CustomIconWidget(
              iconName: 'north_west',
              color: theme.iconTheme.color!.withValues(alpha: 0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingChip({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.chipTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'trending_up',
              color: theme.colorScheme.tertiary,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              text,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem({
    required BuildContext context,
    required String tip,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.8.h),
            width: 1.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              tip,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall!.color!.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
