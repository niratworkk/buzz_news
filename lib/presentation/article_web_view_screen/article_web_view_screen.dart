import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../widgets/custom_icon_widget.dart';
import 'package:share_plus/share_plus.dart';

class ArticleWebViewScreen extends StatefulWidget {
  const ArticleWebViewScreen({super.key});

  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}

class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (error) => setState(() {
            _isLoading = false;
            _error = error.description;
          }),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final article =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Load URL only once when built
    _webViewController.loadRequest(Uri.parse(article['url']));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CustomIconWidget(iconName: 'arrow_back', size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(article['source'] ?? 'Article'),
        actions: [
          IconButton(
            icon: const CustomIconWidget(
              iconName: 'share',
              size: 24,
            ),
            onPressed: () =>
                Share.share('${article['title']}\n\n${article['url']}'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (_error != null)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Failed to load article',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _error = null;
                          _isLoading = true;
                        });
                        _webViewController.reload();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
