import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptySearchResultsWidget extends StatelessWidget {
  final String query;
  final Function(String) onSuggestionTap;

  const EmptySearchResultsWidget({
    super.key,
    required this.query,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = _generateSuggestions(query);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),

          // Empty state illustration
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.tertiary.withValues(alpha: 0.6),
              size: 15.w,
            ),
          ),

          SizedBox(height: 4.h),

          // No results message
          Text(
            'No results found',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
              ),
              children: [
                const TextSpan(text: 'No articles found for '),
                TextSpan(
                  text: '"$query"',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Search suggestions
          if (suggestions.isNotEmpty) ...[
            Text(
              'Try searching for:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...suggestions.map((suggestion) => _buildSuggestionItem(
                  context: context,
                  suggestion: suggestion,
                  onTap: () => onSuggestionTap(suggestion),
                )),
            SizedBox(height: 4.h),
          ],

          // Search tips
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'tips_and_updates',
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Search Tips',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildTipItem(
                  context: context,
                  tip: 'Check your spelling and try again',
                ),
                _buildTipItem(
                  context: context,
                  tip: 'Try more general keywords',
                ),
                _buildTipItem(
                  context: context,
                  tip: 'Use different search terms',
                ),
                _buildTipItem(
                  context: context,
                  tip: 'Remove filters to see more results',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _generateSuggestions(String query) {
    final suggestions = <String>[];

    // Generate related suggestions based on query
    if (query.toLowerCase().contains('flutter')) {
      suggestions.addAll([
        'Flutter development',
        'Flutter news',
        'Mobile development',
        'Cross-platform apps',
      ]);
    } else if (query.toLowerCase().contains('tech')) {
      suggestions.addAll([
        'Technology news',
        'Tech startups',
        'Innovation',
        'Software development',
      ]);
    } else if (query.toLowerCase().contains('ai')) {
      suggestions.addAll([
        'Artificial intelligence',
        'Machine learning',
        'AI technology',
        'Tech innovation',
      ]);
    } else {
      // Default suggestions
      suggestions.addAll([
        'Technology',
        'Mobile development',
        'Software engineering',
        'Tech news',
        'Programming',
      ]);
    }

    return suggestions.take(4).toList();
  }

  Widget _buildSuggestionItem({
    required BuildContext context,
    required String suggestion,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'search',
              color: theme.colorScheme.tertiary,
              size: 18,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                suggestion,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
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
