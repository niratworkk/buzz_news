import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/bookmark_card_widget.dart';
import './widgets/bookmark_search_bar_widget.dart';
import './widgets/empty_bookmarks_widget.dart';

class BookmarksScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const BookmarksScreen({
    super.key,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _bookmarks = [];
  List<Map<String, dynamic>> _filteredBookmarks = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _searchQuery = '';

  // Mock bookmarks data
  final List<Map<String, dynamic>> _mockBookmarks = [
    {
      "id": "1",
      "title": "Flutter 3.16 Released with Material Design 3 Support",
      "description":
          "Google announces Flutter 3.16 with enhanced Material Design 3 theming, improved performance optimizations, and new developer tools for better app development experience.",
      "imageUrl":
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "source": "Flutter Official",
      "publishedAt": "2024-01-15T10:30:00Z",
      "url": "https://flutter.dev/blog/flutter-3-16-release",
      "bookmarkedAt":
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    },
    {
      "id": "2",
      "title": "Dart 3.2 Brings Pattern Matching and Records",
      "description":
          "The latest Dart update introduces powerful pattern matching capabilities and record types, making Flutter development more expressive and type-safe than ever before.",
      "imageUrl":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "source": "Dart Team",
      "publishedAt": "2024-01-14T14:20:00Z",
      "url": "https://dart.dev/blog/dart-3-2-release",
      "bookmarkedAt":
          DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
    },
    {
      "id": "3",
      "title": "Building Responsive UIs with Flutter's New Layout System",
      "description":
          "Learn how to create adaptive layouts that work seamlessly across mobile, tablet, and desktop platforms using Flutter's enhanced responsive design patterns.",
      "imageUrl":
          "https://images.unsplash.com/photo-1551650975-87deedd944c3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "source": "Flutter Community",
      "publishedAt": "2024-01-13T09:15:00Z",
      "url": "https://flutter.dev/docs/development/ui/layout/responsive",
      "bookmarkedAt":
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    },
    {
      "id": "4",
      "title": "State Management in Flutter: Provider vs Riverpod vs Bloc",
      "description":
          "A comprehensive comparison of popular Flutter state management solutions, helping developers choose the right approach for their next project.",
      "imageUrl":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "source": "Flutter Weekly",
      "publishedAt": "2024-01-12T16:45:00Z",
      "url": "https://flutter.dev/docs/development/data-and-backend/state-mgmt",
      "bookmarkedAt":
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    },
    {
      "id": "5",
      "title": "Flutter Web: Performance Optimization Techniques",
      "description":
          "Discover advanced techniques to optimize Flutter web applications for better loading times, smoother animations, and improved user experience across browsers.",
      "imageUrl":
          "https://images.unsplash.com/photo-1498050108023-c5249f4df085?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "source": "Web Dev Today",
      "publishedAt": "2024-01-11T11:30:00Z",
      "url": "https://flutter.dev/web",
      "bookmarkedAt":
          DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterBookmarks();
    });
  }

  void _filterBookmarks() {
    if (_searchQuery.isEmpty) {
      _filteredBookmarks = List.from(_bookmarks);
    } else {
      _filteredBookmarks = _bookmarks.where((bookmark) {
        final title = (bookmark['title'] as String? ?? '').toLowerCase();
        final source = (bookmark['source'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || source.contains(query);
      }).toList();
    }
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = prefs.getString('bookmarks');

      if (bookmarksJson != null) {
        final List<dynamic> bookmarksList = json.decode(bookmarksJson);
        _bookmarks =
            bookmarksList.map((item) => item as Map<String, dynamic>).toList();
      } else {
        // Load mock data for demonstration
        _bookmarks = List.from(_mockBookmarks);
        await _saveBookmarks();
      }

      // Sort by bookmarked date (newest first)
      _bookmarks.sort((a, b) {
        final aDate = DateTime.parse(a['bookmarkedAt'] as String);
        final bDate = DateTime.parse(b['bookmarkedAt'] as String);
        return bDate.compareTo(aDate);
      });

      _filterBookmarks();
    } catch (e) {
      // Handle error - use mock data as fallback
      _bookmarks = List.from(_mockBookmarks);
      _filterBookmarks();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = json.encode(_bookmarks);
      await prefs.setString('bookmarks', bookmarksJson);
    } catch (e) {
      // Handle save error
      debugPrint('Error saving bookmarks: \$e');
    }
  }

  Future<void> _refreshBookmarks() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    await _loadBookmarks();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _removeBookmark(String bookmarkId) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Bookmark',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to remove this article from your bookmarks?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmRemoveBookmark(bookmarkId);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.errorLight,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _confirmRemoveBookmark(String bookmarkId) {
    final removedBookmark = _bookmarks.firstWhere(
      (bookmark) => bookmark['id'] == bookmarkId,
    );

    setState(() {
      _bookmarks.removeWhere((bookmark) => bookmark['id'] == bookmarkId);
      _filterBookmarks();
    });

    _saveBookmarks();

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Bookmark removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _bookmarks.add(removedBookmark);
              _bookmarks.sort((a, b) {
                final aDate = DateTime.parse(a['bookmarkedAt'] as String);
                final bDate = DateTime.parse(b['bookmarkedAt'] as String);
                return bDate.compareTo(aDate);
              });
              _filterBookmarks();
            });
            _saveBookmarks();
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _shareBookmark(Map<String, dynamic> bookmark) {
    final title = bookmark['title'] as String? ?? '';
    final url = bookmark['url'] as String? ?? '';
    final shareText = '\$title\n\n\$url';

    // In a real app, you would use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share: \$shareText'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openInBrowser(Map<String, dynamic> bookmark) {
    final url = bookmark['url'] as String? ?? '';
    // In a real app, you would use url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Open in browser: \$url'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openArticle(Map<String, dynamic> bookmark) {
    Navigator.pushNamed(
      context,
      '/article-web-view-screen',
      arguments: bookmark,
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _filterBookmarks();
    });
  }

  void _navigateToNewsFeed() {
    Navigator.pushReplacementNamed(context, '/news-feed-screen');
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
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
      return '${date.day} ${months[date.month - 1]}, ${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  Map<String, List<Map<String, dynamic>>> _groupBookmarksByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final bookmark in _filteredBookmarks) {
      final dateString = bookmark['bookmarkedAt'] as String? ?? '';
      try {
        final date = DateTime.parse(dateString);
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));

        String groupKey;
        if (date.year == today.year &&
            date.month == today.month &&
            date.day == today.day) {
          groupKey = 'Today';
        } else if (date.year == yesterday.year &&
            date.month == yesterday.month &&
            date.day == yesterday.day) {
          groupKey = 'Yesterday';
        } else {
          groupKey = _formatDate(dateString);
        }

        if (!grouped.containsKey(groupKey)) {
          grouped[groupKey] = [];
        }
        grouped[groupKey]!.add(bookmark);
      } catch (e) {
        // Handle invalid date
        if (!grouped.containsKey('Unknown')) {
          grouped['Unknown'] = [];
        }
        grouped['Unknown']!.add(bookmark);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewsAppBar.bookmarks(
        context: context,
        onSearchPressed: () {
          Navigator.pushNamed(context, '/search-results-screen');
        },
        onThemeToggle: widget.onThemeToggle,
        onLogout: widget.onLogout,
      ),
      body: Column(
        children: [
          BookmarkSearchBarWidget(
            controller: _searchController,
            onClear: _clearSearch,
            searchQuery: _searchQuery,
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _filteredBookmarks.isEmpty
                    ? EmptyBookmarksWidget(
                        onBrowseNews: _navigateToNewsFeed,
                        isSearching: _searchQuery.isNotEmpty,
                        searchQuery: _searchQuery,
                      )
                    : _buildBookmarksList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 12,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookmarksList() {
    final groupedBookmarks = _groupBookmarksByDate();
    final sortedKeys = groupedBookmarks.keys.toList();

    // Sort keys to show Today, Yesterday, then chronological order
    sortedKeys.sort((a, b) {
      if (a == 'Today') return -1;
      if (b == 'Today') return 1;
      if (a == 'Yesterday') return -1;
      if (b == 'Yesterday') return 1;
      if (a == 'Unknown') return 1;
      if (b == 'Unknown') return -1;

      try {
        final aDate = DateTime.parse(a);
        final bDate = DateTime.parse(b);
        return bDate.compareTo(aDate);
      } catch (e) {
        return a.compareTo(b);
      }
    });

    return RefreshIndicator(
      onRefresh: _refreshBookmarks,
      color: Theme.of(context).colorScheme.tertiary,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: sortedKeys.length,
        itemBuilder: (context, index) {
          final dateKey = sortedKeys[index];
          final bookmarks = groupedBookmarks[dateKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              if (index == 0) const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  dateKey,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),

              // Bookmarks for this date
              ...bookmarks.map((bookmark) {
                return BookmarkCardWidget(
                  bookmark: bookmark,
                  onTap: () => _openArticle(bookmark),
                  onRemove: () => _removeBookmark(bookmark['id'] as String),
                  onShare: () => _shareBookmark(bookmark),
                  onOpenInBrowser: () => _openInBrowser(bookmark),
                  formatDate: _formatDate,
                );
              }),

              if (index == sortedKeys.length - 1) const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}
