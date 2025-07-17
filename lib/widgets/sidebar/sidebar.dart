import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplai/blocs/llm_bloc.dart';
import 'package:multiplai/blocs/llm_event.dart';
import 'package:multiplai/blocs/llm_state.dart';
import 'package:multiplai/models/llm_service.dart';

class Sidebar extends StatelessWidget {
  final Function(String serviceName, int pageIndex)? onServiceSelected;
  final List<LLMService>? services;
  final int? selectedIndex;

  const Sidebar({
    super.key,
    this.onServiceSelected,
    this.services,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LLMBloc, LLMState>(
      builder: (context, state) {
        if (state is LLMLoading) {
          return Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[100],
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is LLMError) {
          return Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[100],
            child: Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        }

        if (state is LLMLoaded) {
          return _buildSidebarContent(context, state);
        }

        return Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[100],
        );
      },
    );
  }

  Widget _buildSidebarContent(BuildContext context, LLMLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final servicesToUse = services ?? state.services;
    final selectedIndexToUse = selectedIndex ?? 0;

    return Container(
      color: isDark ? Colors.grey[900] : Colors.grey[100],
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ...servicesToUse.asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;
                return _buildServiceIcon(
                  context,
                  service,
                  index,
                  selectedIndexToUse,
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(
    BuildContext context,
    LLMService service,
    int index,
    int selectedIndex,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: InkWell(
        onTap: () {
          if (onServiceSelected != null) {
            onServiceSelected!(service.name, index);
          } else {
            context.read<LLMBloc>().add(SelectLLMService(service));
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withAlpha(80),
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              service.icon,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.smart_toy,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 16,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
