import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../news_feed_screen/widgets/news_article_card_widget.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  // Mock news data for search
  final List<Map<String, dynamic>> _newsArticles = [
    {
      "id": "1",
      "title": "Flutter 3.16 Released with New Performance Improvements",
      "description":
          "Google announces Flutter 3.16 with significant performance enhancements...",
      "imageUrl":
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?fm=jpg&q=60&w=400&h=300",
      "source": "Flutter Blog",
      "publishedAt": "2024-04-16T10:30:00Z",
      "url": "https://flutter.dev/blog/flutter-3-16",
    },
    // ... add more mock articles if needed
  ];

  @override
  void initState() {
    super.initState();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['query'] != null) {
      _searchController.text = args['query'] as String;
      _performSearch(args['query'] as String);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate network delay

      final results = _newsArticles.where((article) {
        final title = article['title'].toString().toLowerCase();
        final description = article['description'].toString().toLowerCase();
        final source = article['source'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();

        return title.contains(searchQuery) ||
            description.contains(searchQuery) ||
            source.contains(searchQuery);
      }).toList();

      setState(() {
        _searchResults.clear();
        _searchResults.addAll(results);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to perform search';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Search Results',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                suffixIcon: IconButton(
                  icon: const CustomIconWidget(
                    iconName: 'search',
                    size: 24,
                  ),
                  onPressed: () => _performSearch(_searchController.text),
                ),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _searchResults.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final article = _searchResults[index];
                              return NewsArticleCardWidget(
                                title: article['title'] ?? '',
                                description: article['description'] ?? '',
                                imageUrl: article['imageUrl'] ?? '',
                                source: article['source'] ?? '',
                                publishedDate: article['publishedAt'] ?? '',
                                isBookmarked: false,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/article-web-view-screen',
                                  arguments: article,
                                ),
                                onBookmarkTap: () {},
                                onLongPress: () {},
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
