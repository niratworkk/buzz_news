import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showRetryOption = false;
  bool _isOfflineMode = false;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _scaleController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Set status bar style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.primaryColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Ensure full screen
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );

      // Minimum splash display time
      await Future.delayed(const Duration(milliseconds: 1000));

      // Check connectivity
      await _checkConnectivity();

      // Check authentication status
      await _checkAuthenticationStatus();

      // Validate News API connectivity
      await _validateNewsAPI();

      // Load user preferences
      await _loadUserPreferences();

      // Prepare cached bookmark data
      await _prepareCachedData();

      // Navigate based on authentication status
      await _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  Future<void> _checkConnectivity() async {
    setState(() {
      _statusMessage = 'Checking connectivity...';
    });

    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isOfflineMode = true;
        _statusMessage = 'Offline mode enabled';
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    setState(() {
      _statusMessage = 'Checking authentication...';
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final tokenExpiry = prefs.getString('token_expiry');

    if (token != null && tokenExpiry != null) {
      final expiryDate = DateTime.parse(tokenExpiry);
      if (expiryDate.isAfter(DateTime.now())) {
        // Valid session exists
        return;
      } else {
        // Token expired, clear it
        await prefs.remove('auth_token');
        await prefs.remove('token_expiry');
      }
    }
  }

  Future<void> _validateNewsAPI() async {
    if (_isOfflineMode) return;

    setState(() {
      _statusMessage = 'Validating news service...';
    });

    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 5);

      // Test API endpoint (using a simple health check)
      await dio.get(
          'https://newsapi.org/v2/top-headlines?country=us&pageSize=1&apiKey=demo');
    } catch (e) {
      if (!_isOfflineMode) {
        setState(() {
          _statusMessage = 'News service unavailable';
          _showRetryOption = true;
        });

        // Wait for retry or timeout
        await Future.delayed(const Duration(seconds: 3));

        if (_showRetryOption) {
          setState(() {
            _isOfflineMode = true;
            _statusMessage = 'Continuing in offline mode';
            _showRetryOption = false;
          });
        }
      }
    }
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      _statusMessage = 'Loading preferences...';
    });

    final prefs = await SharedPreferences.getInstance();

    // Load theme preference
    final isDarkMode = prefs.getBool('dark_mode') ?? false;

    // Load other preferences
    final lastRefresh = prefs.getString('last_news_refresh');
    final bookmarkCount = prefs.getInt('bookmark_count') ?? 0;

    // Simulate loading time
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _prepareCachedData() async {
    setState(() {
      _statusMessage = 'Preparing cached data...';
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Initialize bookmark storage if not exists
      final bookmarks = prefs.getStringList('bookmarked_articles') ?? [];

      // Validate cached articles
      for (String bookmarkJson in bookmarks) {
        // Basic validation of stored bookmark data
        if (bookmarkJson.isEmpty) {
          bookmarks.remove(bookmarkJson);
        }
      }

      // Update cleaned bookmarks
      await prefs.setStringList('bookmarked_articles', bookmarks);

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // Handle cache preparation errors gracefully
      debugPrint('Cache preparation error: \$e');
    }
  }

  Future<void> _navigateToNextScreen() async {
    setState(() {
      _statusMessage = 'Finalizing...';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final rememberedEmail = prefs.getString('remembered_email');

    // Navigation logic
    if (token != null) {
      // Authenticated user - go to news feed
      Navigator.pushReplacementNamed(context, '/news-feed-screen');
    } else if (rememberedEmail != null) {
      // Returning user with expired session - go to login with pre-filled email
      Navigator.pushReplacementNamed(
        context,
        '/login-screen',
        arguments: {'prefilled_email': rememberedEmail},
      );
    } else {
      // New user - go to login
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  void _handleInitializationError(dynamic error) {
    setState(() {
      _statusMessage = 'Initialization failed';
      _showRetryOption = true;
    });

    // Auto-retry after 5 seconds if no user interaction
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showRetryOption) {
        _retryInitialization();
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _showRetryOption = false;
      _isOfflineMode = false;
      _statusMessage = 'Retrying...';
    });

    _initializeApp();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 0, 0, 0)
          : const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isDark
                    ? const Color.fromARGB(255, 15, 15, 15)
                    : const Color.fromARGB(255, 0, 0, 0),
                isDark
                    ? const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.8)
                    : const Color.fromARGB(255, 9, 9, 9).withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) => AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildAppLogo(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) => Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    'BUZZ NEWS',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: isDark
                          ? const Color.fromARGB(255, 226, 7, 7)
                          : AppTheme.onPrimaryLight,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) => Opacity(
                  opacity: _fadeAnimation.value * 0.8,
                  child: Text(
                    'Stay informed, stay ahead',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: (isDark
                              ? AppTheme.onPrimaryDark
                              : AppTheme.onPrimaryLight)
                          .withValues(alpha: 0.8),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              _buildLoadingSection(theme, isDark),
              const Spacer(flex: 1),
              if (_isOfflineMode) _buildOfflineModeNotice(theme, isDark),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 226, 7, 7),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 226, 7, 7).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'article',
          color: Colors.white,
          size: 64,
        ),
      ),
    );
  }

  Widget _buildLoadingSection(ThemeData theme, bool isDark) {
    return Column(
      children: [
        // Loading Indicator
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : const Color.fromARGB(255, 0, 0, 0),
            ),
            backgroundColor:
                (isDark ? AppTheme.onPrimaryDark : AppTheme.onPrimaryLight)
                    .withValues(alpha: 0.2),
          ),
        ),

        const SizedBox(height: 16),

        // Status Message
        Text(
          _statusMessage,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: (isDark ? AppTheme.onPrimaryDark : AppTheme.onPrimaryLight)
                .withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        // Retry Button
        if (_showRetryOption) ...[
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _retryInitialization,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 84, 76, 76),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Retry',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOfflineModeNotice(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 212, 204).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              const Color.fromARGB(255, 198, 195, 189).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'wifi_off',
            color: AppTheme.warningLight,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Running in offline mode. Some features may be limited.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.warningLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
