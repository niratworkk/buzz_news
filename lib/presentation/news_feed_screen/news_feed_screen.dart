import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/news_article_card_widget.dart';
import './widgets/news_skeleton_card_widget.dart';
import './widgets/search_overlay_widget.dart';

class NewsFeedScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const NewsFeedScreen({
    super.key,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _showSearchOverlay = false;
  bool _isDarkMode = false;
  int _currentPage = 1;
  List<String> _bookmarkedArticles = [];

  // TODO: For persistent bookmarks, use SharedPreferences or a provider.
  // Mock news data
  final List<Map<String, dynamic>> _newsArticles = [
    {
      "id": "1",
      "title": "Flutter 3.16 Released with New Performance Improvements",
      "description":
          "Google announces Flutter 3.16 with significant performance enhancements, new widgets, and improved developer experience for cross-platform development.",
      "imageUrl":
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?fm=jpg&q=60&w=400&h=300",
      "source": "Flutter Blog",
      "publishedAt": "2024-04-16T10:30:00Z",
      "url": "https://flutter.dev/blog/flutter-3-16",
      "content":
          "Flutter 3.16 brings exciting new features and performance improvements..."
    },
    {
      "id": "2",
      "title": "Dart 3.3 Introduces Advanced Pattern Matching",
      "description":
          "The latest Dart update brings powerful pattern matching capabilities, making code more expressive and reducing boilerplate in Flutter applications.",
      "imageUrl":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?fm=jpg&q=60&w=400&h=300",
      "source": "Dart Team",
      "publishedAt": "2024-04-15T14:20:00Z",
      "url": "https://dart.dev/blog/dart-3-3",
      "content":
          "Dart 3.3 pattern matching revolutionizes how we write Dart code..."
    },
    {
      "id": "3",
      "title": "Material Design 3 Integration in Flutter Applications",
      "description":
          "Learn how to implement Material Design 3 (Material You) in your Flutter apps with dynamic theming and adaptive color schemes.",
      "imageUrl":
          "https://images.unsplash.com/photo-1558655146-9f40138edfeb?fm=jpg&q=60&w=400&h=300",
      "source": "Material Design",
      "publishedAt": "2024-04-14T09:15:00Z",
      "url": "https://material.io/blog/material-design-flutter",
      "content":
          "Material Design 3 brings a fresh approach to Flutter UI design..."
    },
    {
      "id": "4",
      "title": "State Management Best Practices in Flutter 2024",
      "description":
          "Comprehensive guide to choosing the right state management solution for your Flutter project, comparing Provider, Riverpod, and Bloc patterns.",
      "imageUrl":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=400&h=300",
      "source": "Flutter Community",
      "publishedAt": "2024-04-13T16:45:00Z",
      "url": "https://flutter.dev/state-management",
      "content":
          "State management is crucial for building scalable Flutter apps..."
    },
    {
      "id": "5",
      "title": "Firebase Integration with Flutter: Complete Tutorial",
      "description":
          "Step-by-step guide to integrating Firebase services including Authentication, Firestore, and Cloud Functions in your Flutter mobile application.",
      "imageUrl":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?fm=jpg&q=60&w=400&h=300",
      "source": "Firebase Team",
      "publishedAt": "2024-04-12T11:30:00Z",
      "url": "https://firebase.google.com/flutter",
      "content":
          "Firebase provides a comprehensive backend solution for Flutter..."
    },
    {
      "id": "6",
      "title": "Flutter Web Performance Optimization Techniques",
      "description":
          "Advanced strategies for optimizing Flutter web applications including code splitting, lazy loading, and efficient rendering techniques.",
      "imageUrl":
          "https://images.unsplash.com/photo-1467232004584-a241de8bcf5d?fm=jpg&q=60&w=400&h=300",
      "source": "Web Dev",
      "publishedAt": "2024-04-11T13:20:00Z",
      "url": "https://flutter.dev/web-performance",
      "content": "Optimizing Flutter web apps requires specific techniques..."
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final bookmarksJson = prefs.getString('bookmarks') ?? '[]';
      final bookmarks = json.decode(bookmarksJson) as List;
      setState(() {
        _bookmarkedArticles = bookmarks.map((b) => b['id'].toString()).toList();
      });
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreArticles();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMoreArticles() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more articles
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _currentPage++;
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshNews() async {
    HapticFeedback.lightImpact();

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _currentPage = 1;
    });
  }

  Future<void> _toggleBookmark(String articleId) async {
    HapticFeedback.selectionClick();
    final prefs = await SharedPreferences.getInstance();

    try {
      // Load existing bookmarks
      final bookmarksJson = prefs.getString('bookmarks') ?? '[]';
      List<Map<String, dynamic>> bookmarks = List<Map<String, dynamic>>.from(
          json.decode(bookmarksJson).map((x) => Map<String, dynamic>.from(x)));

      final article = _newsArticles.firstWhere((a) => a['id'] == articleId);

      if (_bookmarkedArticles.contains(articleId)) {
        _bookmarkedArticles.remove(articleId);
        bookmarks.removeWhere((b) => b['id'] == articleId);
      } else {
        _bookmarkedArticles.add(articleId);
        article['bookmarkedAt'] = DateTime.now().toIso8601String();
        bookmarks.add(article);
      }

      // Save updated bookmarks
      await prefs.setString('bookmarks', json.encode(bookmarks));

      setState(() {});
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
    }
  }

  void _toggleTheme() {
    HapticFeedback.lightImpact();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showSearch() {
    setState(() {
      _showSearchOverlay = true;
    });
  }

  void _hideSearch() {
    setState(() {
      _showSearchOverlay = false;
    });
  }

  void _navigateToArticle(Map<String, dynamic> article) {
    Navigator.pushNamed(
      context,
      '/article-detail-screen', // Update route name
      arguments: article,
    );
  }

  void _showArticleContextMenu(Map<String, dynamic> article) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: _bookmarkedArticles.contains(article["id"])
                      ? 'bookmark'
                      : 'bookmark_border',
                  color: _bookmarkedArticles.contains(article["id"])
                      ? AppTheme.bookmarkActiveLight
                      : Theme.of(context).iconTheme.color!,
                  size: 24,
                ),
                title: Text(
                  _bookmarkedArticles.contains(article["id"])
                      ? 'Remove Bookmark'
                      : 'Add Bookmark',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _toggleBookmark(article["id"]);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: Theme.of(context).iconTheme.color!,
                  size: 24,
                ),
                title: const Text('Share Article'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'open_in_new',
                  color: Theme.of(context).iconTheme.color!,
                  size: 24,
                ),
                title: const Text('View Source'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToArticle(article);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final List<String> months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '[${date.day} ${months[date.month - 1]}, ${date.year}]';
    } catch (e) {
      return '[Date unavailable]';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: NewsAppBar.newsFeed(
          context: context,
          onSearchPressed: _showSearch,
          onThemeToggle: widget.onThemeToggle,
          onLogout: widget.onLogout,
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshNews,
              color: Theme.of(context).colorScheme.tertiary,
              child: _isLoading
                  ? _buildLoadingState()
                  : _newsArticles.isEmpty
                      ? _buildEmptyState()
                      : _buildNewsList(),
            ),
            if (_showSearchOverlay)
              SearchOverlayWidget(
                onClose: _hideSearch,
                onSearch: (query) {
                  Navigator.pushNamed(
                    context,
                    '/search-results-screen',
                    arguments: {'query': query},
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) => const NewsSkeletonCardWidget(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'article',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No articles available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull to refresh and get the latest news',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _newsArticles.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _newsArticles.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final article = _newsArticles[index];
        final isBookmarked = _bookmarkedArticles.contains(article["id"]);

        return NewsArticleCardWidget(
          title: article["title"] ?? '',
          description: article["description"] ?? '',
          imageUrl: article["imageUrl"] ?? '',
          source: article["source"] ?? '',
          publishedDate: _formatDate(article["publishedAt"] ?? ''),
          isBookmarked: isBookmarked,
          onTap: () => _navigateToArticle(article),
          onBookmarkTap: () => _toggleBookmark(article["id"]),
          onLongPress: () => _showArticleContextMenu(article),
        );
      },
    );
  }
}
