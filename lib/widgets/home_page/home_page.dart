import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplai/blocs/llm_bloc.dart';
import 'package:multiplai/blocs/llm_event.dart';
import 'package:multiplai/blocs/llm_state.dart';
import 'package:multiplai/widgets/index.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, WebviewController> _webviewControllers = {};
  final Map<String, Widget> _webviewWidgets = {};
  int _currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LLMBloc, LLMState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: state is LLMLoaded
              ? Drawer(
                  child: HamburgerMenu(
                    onServiceSelected: _onServiceSelected,
                    services: state.services,
                    selectedIndex: _currentPageIndex,
                    onClose: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              : null,
          body: LayoutBuilder(
            builder: (context, constraints) {
              // Check if screen width is mobile size (less than 600px)
              final isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                return MobileLayout(
                  scaffoldKey: _scaffoldKey,
                  webviewControllers: _webviewControllers,
                  webviewWidgets: _webviewWidgets,
                  currentPageIndex: _currentPageIndex,
                );
              } else {
                return DesktopLayout(
                  onServiceSelected: _onServiceSelected,
                  webviewControllers: _webviewControllers,
                  webviewWidgets: _webviewWidgets,
                  currentPageIndex: _currentPageIndex,
                );
              }
            },
          ),
        );
      },
    );
  }
}
