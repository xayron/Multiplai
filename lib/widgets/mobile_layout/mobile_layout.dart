import 'package:flutter/material.dart';
import 'package:multiplai/widgets/index.dart';

class MobileLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Map<String, WebviewController> webviewControllers;
  final Map<String, Widget> webviewWidgets;
  final int currentPageIndex;

  const MobileLayout({
    super.key,
    required this.scaffoldKey,
    required this.webviewControllers,
    required this.webviewWidgets,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar
        MobileAppBar(scaffoldKey: scaffoldKey),
        // Content Area
        Expanded(
          child: ContentArea(
            webviewControllers: webviewControllers,
            webviewWidgets: webviewWidgets,
            currentPageIndex: currentPageIndex,
          ),
        ),
      ],
    );
  }
}
