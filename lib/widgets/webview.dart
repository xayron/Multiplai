import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:multiplai/services/cache_service.dart';

class Webview extends StatefulWidget {
  final String initialUrl;
  final String serviceName;

  const Webview({
    super.key,
    this.initialUrl = 'https://chat.openai.com',
    required this.serviceName,
  });

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> with AutomaticKeepAliveClientMixin {
  late InAppWebViewController _webViewController;
  String _currentUrl = '';
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true; // This prevents the widget from being disposed

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
  }

  void loadUrl(String url) {
    if (_webViewController != null) {
      setState(() {
        _isLoading = true;
      });
      _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
      setState(() {
        _currentUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Column(
      children: [
        _buildUrlBar(),
        Expanded(child: _buildWebview()),
      ],
    );
  }

  Widget _buildUrlBar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Reset button
          InkWell(
            onTap: _resetToOriginalUrl,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.refresh,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.lock_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _currentUrl,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (_isLoading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }

  void _resetToOriginalUrl() {
    if (_webViewController != null) {
      setState(() {
        _isLoading = true;
      });
      _webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri(widget.initialUrl)),
      );
      setState(() {
        _currentUrl = widget.initialUrl;
      });
    }
  }

  Widget _buildWebview() {
    return Stack(
      children: [
        InAppWebView(
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            allowsInlineMediaPlayback: true,
            mediaPlaybackRequiresUserGesture: false,
            useOnLoadResource: true,
            cacheEnabled: true,
            clearCache: false,
            supportZoom: false,
            // Enable persistent storage
            databaseEnabled: true,
            domStorageEnabled: true,
            // Enable cookies and session storage
            // Enable file access for better caching
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            // Enable mixed content for better compatibility
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            // Enable safe browsing
            safeBrowsingEnabled: true,
            // Enable third-party cookies for login persistence
            thirdPartyCookiesEnabled: true,
          ),
          initialUrlRequest: URLRequest(url: WebUri(_currentUrl)),
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              _isLoading = true;
              _currentUrl = url?.toString() ?? '';
            });
          },
          onLoadStop: (controller, url) {
            setState(() {
              _isLoading = false;
            });
          },
          onLoadError: (controller, url, code, message) {
            setState(() {
              _isLoading = false;
            });
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
        ),
        if (_isLoading)
          Container(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class WebviewController {
  final GlobalKey<_WebviewState> _key = GlobalKey<_WebviewState>();

  void loadUrl(String url) {
    _key.currentState?.loadUrl(url);
  }

  GlobalKey<_WebviewState> get key => _key;
}
