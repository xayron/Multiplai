import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'webview_url_bar.dart';
import 'webview_stack.dart';

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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
  }

  void loadUrl(String url) {
    setState(() {
      _isLoading = true;
    });
    _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    setState(() {
      _currentUrl = url;
    });
  }

  void _resetToOriginalUrl() {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        WebviewUrlBar(
          currentUrl: _currentUrl,
          isLoading: _isLoading,
          onRefresh: _resetToOriginalUrl,
        ),
        Expanded(
          child: WebviewStack(
            currentUrl: _currentUrl,
            isLoading: _isLoading,
            onWebViewCreated: (controller) {
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
