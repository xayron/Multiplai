import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewStack extends StatelessWidget {
  final InAppWebViewController? controller;
  final String currentUrl;
  final bool isLoading;
  final void Function(InAppWebViewController)? onWebViewCreated;
  final void Function(InAppWebViewController, Uri?)? onLoadStart;
  final void Function(InAppWebViewController, Uri?)? onLoadStop;
  final void Function(InAppWebViewController, Uri?, int, String)? onLoadError;
  final Future<PermissionResponse> Function(
    InAppWebViewController,
    PermissionRequest,
  )?
  onPermissionRequest;

  const WebviewStack({
    super.key,
    this.controller,
    required this.currentUrl,
    required this.isLoading,
    this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.onLoadError,
    this.onPermissionRequest,
  });

  @override
  Widget build(BuildContext context) {
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
            databaseEnabled: true,
            domStorageEnabled: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            safeBrowsingEnabled: true,
            thirdPartyCookiesEnabled: true,
          ),
          initialUrlRequest: URLRequest(url: WebUri(currentUrl)),
          onWebViewCreated: onWebViewCreated,
          onLoadStart: onLoadStart,
          onLoadStop: onLoadStop,
          onLoadError: onLoadError,
          onPermissionRequest: onPermissionRequest,
        ),
        if (isLoading)
          Container(
            color: Theme.of(
              context,
            ).colorScheme.surface.withAlpha((0.8 * 10).toInt()),
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
