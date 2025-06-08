import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SearchResultCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String source;
  final String publishedAt;
  final String imageUrl;
  final bool isBookmarked;
  final String searchQuery;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback? onLongPress;

  const SearchResultCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.isBookmarked,
    required this.searchQuery,
    required this.onTap,
    required this.onBookmarkTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: 20.w,
                  height: 15.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),

              // Article Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with search highlighting
                    _buildHighlightedText(
                      text: title,
                      searchQuery: searchQuery,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      highlightStyle: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        backgroundColor:
                            theme.colorScheme.tertiary.withValues(alpha: 0.2),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    // Description with search highlighting
                    _buildHighlightedText(
                      text: description,
                      searchQuery: searchQuery,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.textTheme.bodyMedium!.color!
                            .withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                      highlightStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.textTheme.bodyMedium!.color!
                            .withValues(alpha: 0.8),
                        height: 1.4,
                        backgroundColor:
                            theme.colorScheme.tertiary.withValues(alpha: 0.2),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 1.5.h),

                    // Source and Date Row
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'article',
                                color: theme.iconTheme.color!
                                    .withValues(alpha: 0.6),
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Flexible(
                                child: Text(
                                  source,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.tertiary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          publishedAt,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.textTheme.labelSmall!.color!
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bookmark Button
              Column(
                children: [
                  IconButton(
                    onPressed: onBookmarkTap,
                    icon: CustomIconWidget(
                      iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
                      color: isBookmarked
                          ? AppTheme.bookmarkActiveLight
                          : theme.iconTheme.color!.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText({
    required String text,
    required String searchQuery,
    required TextStyle style,
    required TextStyle highlightStyle,
    int? maxLines,
  }) {
    if (searchQuery.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
      );
    }

    final query = searchQuery.toLowerCase();
    final lowerText = text.toLowerCase();
    final spans = <TextSpan>[];

    int start = 0;
    int index = lowerText.indexOf(query);

    while (index != -1) {
      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: style,
        ));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: highlightStyle,
      ));

      start = index + query.length;
      index = lowerText.indexOf(query, start);
    }

    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }
}
