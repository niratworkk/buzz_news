import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/article_web_view_screen/article_web_view_screen.dart';
import '../presentation/search_results_screen/search_results_screen.dart';
import '../presentation/article_detail_screen/article_detail_screen.dart';

class AppRoutes {
  static const String initial = '/splash-screen';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String newsFeedScreen = '/news-feed-screen';
  static const String bookmarksScreen = '/bookmarks-screen';
  static const String articleWebViewScreen = '/article-web-view-screen';
  static const String searchResultsScreen = '/search-results-screen';
  static const String articleDetailScreen = '/article-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    articleWebViewScreen: (context) => const ArticleWebViewScreen(),
    searchResultsScreen: (context) => const SearchResultsScreen(),
    articleDetailScreen: (context) => const ArticleDetailScreen(),
  };
}
