import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class ArticleHeaderWidget extends StatelessWidget {
  final String title;
  final bool isBookmarked;
  final VoidCallback onBackPressed;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onSharePressed;
  final double loadingProgress;
  final bool isLoading;

  const ArticleHeaderWidget({
    super.key,
    required this.title,
    required this.isBookmarked,
    required this.onBackPressed,
    required this.onBookmarkPressed,
    required this.onSharePressed,
    required this.loadingProgress,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header content
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                // Back button
                IconButton(
                  onPressed: onBackPressed,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back_ios',
                    color: theme.appBarTheme.foregroundColor!,
                    size: 20,
                  ),
                  tooltip: 'Back',
                ),

                // Title
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.appBarTheme.foregroundColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // Bookmark button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: onBookmarkPressed,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: CustomIconWidget(
                        key: ValueKey(isBookmarked),
                        iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
                        color: isBookmarked
                            ? AppTheme.bookmarkActiveLight
                            : theme.appBarTheme.foregroundColor!,
                        size: 24,
                      ),
                    ),
                    tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
                  ),
                ),

                // Share button
                IconButton(
                  onPressed: onSharePressed,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: theme.appBarTheme.foregroundColor!,
                    size: 24,
                  ),
                  tooltip: 'Share article',
                ),

                const SizedBox(width: 4),
              ],
            ),
          ),

          // Loading progress bar
          if (isLoading)
            SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                value: loadingProgress,
                backgroundColor: theme.dividerColor.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.tertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
