import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplai/blocs/llm_bloc.dart';
import 'package:multiplai/blocs/llm_state.dart';
import 'package:multiplai/models/llm_service.dart';
import 'package:multiplai/widgets/index.dart';

class ContentArea extends StatelessWidget {
  final Map<String, WebviewController> webviewControllers;
  final Map<String, Widget> webviewWidgets;
  final int currentPageIndex;

  const ContentArea({
    super.key,
    required this.webviewControllers,
    required this.webviewWidgets,
    required this.currentPageIndex,
  });

  Widget _createWebviewWidget(LLMService service, LLMState state) {
    final serviceName = service.name;

    // Create webview controller if not exists
    if (!webviewControllers.containsKey(serviceName)) {
      webviewControllers[serviceName] = WebviewController();
    }

    // Create webview widget if not exists
    if (!webviewWidgets.containsKey(serviceName)) {
      webviewWidgets[serviceName] = Webview(
        key: ValueKey('webview_$serviceName'),
        initialUrl: state is LLMLoaded
            ? (state.webviewUrls[serviceName] ?? service.url)
            : service.url,
        serviceName: serviceName,
      );
    }

    return webviewWidgets[serviceName]!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LLMBloc, LLMState>(
      builder: (context, state) {
        return _buildContentArea(context, state);
      },
    );
  }

  Widget _buildContentArea(BuildContext context, LLMState state) {
    if (state is LLMInitial || state is LLMLoading) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is LLMError) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.message}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is LLMLoaded) {
      // Create all webview widgets for IndexedStack
      final webviewWidgets = state.services.map((service) {
        final serviceName = service.name;
        final isLoading = state.loadingStates[serviceName] ?? false;

        if (isLoading) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading $serviceName...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _createWebviewWidget(service, state);
      }).toList();

      return IndexedStack(index: currentPageIndex, children: webviewWidgets);
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smart_toy_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Select an AI service to get started',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
