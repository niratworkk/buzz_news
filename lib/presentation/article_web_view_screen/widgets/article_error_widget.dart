import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ArticleErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onGoBack;

  const ArticleErrorWidget({
    super.key,
    required this.onRetry,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'error_outline',
              color: theme.colorScheme.error,
              size: 40,
            ),
          ),

          const SizedBox(height: 24),

          // Error title
          Text(
            'Failed to Load Article',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Error description
          Text(
            'We couldn\'t load this article. Please check your internet connection and try again.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Action buttons
          Column(
            children: [
              // Retry button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: theme.elevatedButtonTheme.style?.foregroundColor
                            ?.resolve({}) ??
                        Colors.white,
                    size: 20,
                  ),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Go back button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onGoBack,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: theme.outlinedButtonTheme.style?.foregroundColor
                            ?.resolve({}) ??
                        theme.colorScheme.primary,
                    size: 20,
                  ),
                  label: const Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Network diagnostics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Troubleshooting Tips',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTroubleshootingItem(
                  context,
                  'Check your internet connection',
                  'wifi',
                ),
                const SizedBox(height: 8),
                _buildTroubleshootingItem(
                  context,
                  'Try switching between WiFi and mobile data',
                  'swap_horiz',
                ),
                const SizedBox(height: 8),
                _buildTroubleshootingItem(
                  context,
                  'Close and reopen the app',
                  'refresh',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingItem(
    BuildContext context,
    String text,
    String iconName,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
