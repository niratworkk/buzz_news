import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../news_feed_screen/news_feed_screen.dart';
import '../bookmarks_screen/bookmarks_screen.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavigationItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all preferences except theme setting
    final isDarkMode = prefs.getBool('dark_mode');
    await prefs.clear();
    if (isDarkMode != null) {
      await prefs.setBool('dark_mode', isDarkMode);
    }

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login-screen',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe
          children: [
            NewsFeedScreen(
              onThemeToggle: widget.onThemeToggle,
              onLogout: _handleLogout,
            ),
            BookmarksScreen(
              onThemeToggle: widget.onThemeToggle,
              onLogout: _handleLogout,
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavigationItemTapped,
        ),
      ),
    );
  }
}
