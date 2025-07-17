import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplai/blocs/llm_bloc.dart';
import 'package:multiplai/blocs/llm_state.dart';
import 'package:multiplai/widgets/sidebar.dart';
import 'package:multiplai/widgets/content_area.dart';
import 'package:multiplai/widgets/webview.dart';

class DesktopLayout extends StatelessWidget {
  final Function(String serviceName, int pageIndex) onServiceSelected;
  final Map<String, WebviewController> webviewControllers;
  final Map<String, Widget> webviewWidgets;
  final int currentPageIndex;

  const DesktopLayout({
    super.key,
    required this.onServiceSelected,
    required this.webviewControllers,
    required this.webviewWidgets,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<LLMBloc, LLMState>(
          builder: (context, state) {
            if (state is LLMLoaded) {
              return Sidebar(
                onServiceSelected: onServiceSelected,
                services: state.services,
                selectedIndex: currentPageIndex,
              );
            }
            return const Sidebar();
          },
        ),
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
