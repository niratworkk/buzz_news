import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.brandBlack
            : AppTheme.brandWhite,
        boxShadow: [
          BoxShadow(
            color: AppTheme.brandPrimaryRed.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize:
                MainAxisSize.max, // Ensure Row takes all available width
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                iconName: 'article',
                label: 'News',
                route: '/news-feed-screen',
              ),
              _buildNavItem(
                context: context,
                index: 1,
                iconName: 'bookmark',
                label: 'Bookmarks',
                route: '/bookmarks-screen',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconName,
    required String label,
    required String route,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentIndex == index;
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor!;
    final unselectedColor = theme.bottomNavigationBarTheme.unselectedItemColor!;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index), // Just call onTap, remove navigation
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.brandPrimaryRed.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: isSelected ? AppTheme.brandPrimaryRed : unselectedColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: isSelected
                  ? theme.bottomNavigationBarTheme.selectedLabelStyle!.copyWith(
                      color: selectedColor,
                    )
                  : theme.bottomNavigationBarTheme.unselectedLabelStyle!
                      .copyWith(
                      color: unselectedColor,
                    ),
              child: Text(label, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
