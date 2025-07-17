import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplai/blocs/llm_bloc.dart';
import 'package:multiplai/blocs/llm_event.dart';
import 'package:multiplai/blocs/llm_state.dart';
import 'package:multiplai/models/llm_service.dart';
import 'package:multiplai/widgets/webview.dart';
import 'package:multiplai/widgets/sidebar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, WebviewController> _webviewControllers = {};
  final Map<String, Widget> _webviewWidgets = {};
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<LLMBloc>().add(const LoadLLMServices());
  }

  void _onServiceSelected(String serviceName, int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  Widget _createWebviewWidget(LLMService service, LLMState state) {
    final serviceName = service.name;

    // Create webview controller if not exists
    if (!_webviewControllers.containsKey(serviceName)) {
      _webviewControllers[serviceName] = WebviewController();
    }

    // Create webview widget if not exists
    if (!_webviewWidgets.containsKey(serviceName)) {
      _webviewWidgets[serviceName] = Webview(
        key: ValueKey('webview_$serviceName'),
        initialUrl: state is LLMLoaded
            ? (state.webviewUrls[serviceName] ?? service.url)
            : service.url,
        serviceName: serviceName,
      );
    }

    return _webviewWidgets[serviceName]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          BlocBuilder<LLMBloc, LLMState>(
            builder: (context, state) {
              if (state is LLMLoaded) {
                return Sidebar(
                  onServiceSelected: _onServiceSelected,
                  services: state.services,
                  selectedIndex: _currentPageIndex,
                );
              }
              return const Sidebar();
            },
          ),
          Expanded(
            child: BlocBuilder<LLMBloc, LLMState>(
              builder: (context, state) {
                return _buildContentArea(state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea(LLMState state) {
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

      return IndexedStack(index: _currentPageIndex, children: webviewWidgets);
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
