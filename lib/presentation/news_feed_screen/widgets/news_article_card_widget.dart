import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_export.dart';

class NewsArticleCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedDate;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback? onLongPress;

  const NewsArticleCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedDate,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmarkTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: theme.cardTheme.elevation,
      shadowColor: theme.cardTheme.shadowColor,
      shape: theme.cardTheme.shape,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        onLongPress: onLongPress != null
            ? () {
                HapticFeedback.mediumImpact();
                onLongPress!();
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnail(context),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 80,
        height: 80,
        child: imageUrl.isNotEmpty
            ? CustomImageWidget(
                imageUrl: imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
            : Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: CustomIconWidget(
                  iconName: 'image',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 32,
                ),
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildBookmarkButton(context),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        _buildMetadata(context),
      ],
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onBookmarkTap();
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isBookmarked
              ? AppTheme.bookmarkActiveLight.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: CustomIconWidget(
            key: ValueKey(isBookmarked),
            iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
            color: isBookmarked
                ? AppTheme.bookmarkActiveLight
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'source',
                color: theme.colorScheme.onSurfaceVariant,
                size: 14,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  source,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: theme.colorScheme.onSurfaceVariant,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              publishedDate,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
