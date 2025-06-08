import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyBookmarksWidget extends StatelessWidget {
  final VoidCallback onBrowseNews;
  final bool isSearching;
  final String searchQuery;

  const EmptyBookmarksWidget({
    super.key,
    required this.onBrowseNews,
    this.isSearching = false,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: isSearching ? 'search_off' : 'bookmark_border',
                color: theme.colorScheme.tertiary,
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              isSearching ? 'No results found' : 'No bookmarks yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              isSearching
                  ? 'No bookmarks match "\$searchQuery".\nTry a different search term.'
                  : 'Start bookmarking articles to read them later.\nYour saved articles will appear here.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action Button
            if (!isSearching) ...[
              ElevatedButton.icon(
                onPressed: onBrowseNews,
                icon: CustomIconWidget(
                  iconName: 'article',
                  color: theme.elevatedButtonTheme.style?.foregroundColor
                          ?.resolve({}) ??
                      Colors.white,
                  size: 20,
                ),
                label: const Text('Browse News'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ] else ...[
              OutlinedButton.icon(
                onPressed: () {
                  // Clear search would be handled by parent
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: const Text('Clear Search'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Additional suggestions
            if (isSearching) ...[
              Text(
                'Search tips:',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Try shorter keywords\n• Check for typos\n• Search by source name',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb_outline',
                      color: theme.colorScheme.tertiary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Tip: Tap the bookmark icon on any article to save it here',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
