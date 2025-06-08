import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final TextStyle? titleStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: titleStyle ??
            appBarTheme.titleTextStyle?.copyWith(
              color: foregroundColor ?? appBarTheme.foregroundColor,
            ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
      elevation: elevation,
      shadowColor: appBarTheme.shadowColor,
      surfaceTintColor: appBarTheme.surfaceTintColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: _buildLeading(context),
      actions: _buildActions(context),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (backgroundColor ?? appBarTheme.backgroundColor!),
              (backgroundColor ?? appBarTheme.backgroundColor!)
                  .withValues(alpha: 0.95),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton ||
        (automaticallyImplyLeading && Navigator.canPop(context))) {
      return IconButton(
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color:
              foregroundColor ?? Theme.of(context).appBarTheme.foregroundColor!,
          size: 20,
        ),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: action,
        );
      }
      return action;
    }).toList();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NewsAppBar extends CustomAppBar {
  const NewsAppBar({
    super.key,
    required super.title,
    super.actions,
    super.titleStyle,
    VoidCallback? onSearchPressed,
    required VoidCallback onThemeToggle, // Make this required
    bool showSearch = true,
    bool showThemeToggle = true,
  }) : super(
          showBackButton: false,
          automaticallyImplyLeading: false, // Ensure no back arrow
        );

  static NewsAppBar newsFeed({
    VoidCallback? onSearchPressed,
    required VoidCallback onThemeToggle,
    required VoidCallback onLogout,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return NewsAppBar(
      title: '',
      onThemeToggle: onThemeToggle,
      actions: [
        // Custom Buzz News Logo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BUZZ',
                style: TextStyle(
                  color: AppTheme.brandPrimaryRed,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'NEWS',
                style: TextStyle(
                  color: isDark ? AppTheme.brandWhite : AppTheme.brandBlack,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Existing action buttons
        IconButton(
          onPressed: onSearchPressed ?? () {},
          icon: CustomIconWidget(
            iconName: 'search',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: 'Search',
        ),
        IconButton(
          onPressed: onThemeToggle,
          icon: CustomIconWidget(
            iconName: Theme.of(context).brightness == Brightness.dark
                ? 'light_mode'
                : 'dark_mode',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: 'Toggle theme',
        ),
        IconButton(
          onPressed: () => _showLogoutDialog(context, onLogout),
          icon: CustomIconWidget(
            iconName: 'logout',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: 'Logout',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  static void _showLogoutDialog(BuildContext context, VoidCallback onLogout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onLogout();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  static NewsAppBar bookmarks({
    VoidCallback? onSearchPressed,
    required VoidCallback onThemeToggle, // Make this required
    required VoidCallback onLogout,
    required BuildContext context,
  }) {
    return NewsAppBar(
      title: 'Bookmarks',
      titleStyle: TextStyle(
        color: AppTheme.brandPrimaryRed,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontFamily: 'Inter',
      ),
      onThemeToggle: onThemeToggle,
      actions: [
        IconButton(
          onPressed: onSearchPressed ?? () {},
          icon: CustomIconWidget(
            iconName: 'search',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: 'Search',
        ),
        IconButton(
          onPressed: onThemeToggle,
          icon: CustomIconWidget(
            iconName: Theme.of(context).brightness == Brightness.dark
                ? 'light_mode'
                : 'dark_mode',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: 'Toggle theme',
        ),
        IconButton(
          onPressed: () => _showLogoutDialog(context, onLogout),
          icon: CustomIconWidget(
            iconName: 'logout',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: 'Logout',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  static CustomAppBar article({
    required String title,
    VoidCallback? onBackPressed,
    VoidCallback? onSharePressed,
    VoidCallback? onBookmarkPressed,
    bool isBookmarked = false,
    required BuildContext context,
  }) {
    return CustomAppBar(
      title: title,
      showBackButton: true,
      onBackPressed: onBackPressed,
      actions: [
        IconButton(
          onPressed: onBookmarkPressed ?? () {},
          icon: CustomIconWidget(
            iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
            color: isBookmarked
                ? const Color(0xFF10B981)
                : Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
        ),
        IconButton(
          onPressed: onSharePressed ?? () {},
          icon: CustomIconWidget(
            iconName: 'share',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          tooltip: 'Share',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  static CustomAppBar search({
    VoidCallback? onBackPressed,
    Widget? searchField,
    required BuildContext context,
  }) {
    return CustomAppBar(
      title: '',
      showBackButton: true,
      onBackPressed: onBackPressed,
      centerTitle: false,
      actions: searchField != null
          ? [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  child: searchField,
                ),
              ),
            ]
          : null,
    );
  }
}
