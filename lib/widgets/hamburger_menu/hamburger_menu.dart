import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplai/blocs/llm_bloc.dart';
import 'package:multiplai/blocs/llm_event.dart';
import 'package:multiplai/blocs/llm_state.dart';
import 'package:multiplai/models/llm_service.dart';
import 'package:multiplai/widgets/hamburger_menu/index.dart';

class HamburgerMenu extends StatelessWidget {
  final Function(String serviceName, int pageIndex)? onServiceSelected;
  final List<LLMService>? services;
  final int? selectedIndex;
  final VoidCallback? onClose;

  const HamburgerMenu({
    super.key,
    this.onServiceSelected,
    this.services,
    this.selectedIndex,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LLMBloc, LLMState>(
      builder: (context, state) {
        if (state is LLMLoading) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is LLMError) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        }

        if (state is LLMLoaded) {
          return _buildMenuContent(context, state);
        }

        return Container(color: Theme.of(context).colorScheme.surface);
      },
    );
  }

  Widget _buildMenuContent(BuildContext context, LLMLoaded state) {
    final servicesToUse = services ?? state.services;
    final selectedIndexToUse = selectedIndex ?? 0;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withAlpha((0.2 * 10).toInt()),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_toy, size: 24),
                const SizedBox(width: 12),
                Text(
                  'AI Services',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const Spacer(),
                if (onClose != null)
                  IconButton(
                    onPressed: onClose,
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
              ],
            ),
          ),
          // Services list
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: servicesToUse.length,
                itemExtent: 64.0,
                cacheExtent: 512.0,
                itemBuilder: (context, index) {
                  final service = servicesToUse[index];
                  return _buildServiceItem(
                    context,
                    service,
                    index,
                    selectedIndexToUse,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    LLMService service,
    int index,
    int selectedIndex,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onServiceSelected != null) {
              onServiceSelected!(service.name, index);
            } else {
              context.read<LLMBloc>().add(SelectLLMService(service));
            }
            // Close menu after selection on mobile
            if (onClose != null) {
              onClose!();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Service icon with platform-aware caching
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withAlpha(80),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: PlatformAwareImage(
                      url: service.icon,
                      isDark: isDark,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Service name
                Expanded(
                  child: Text(
                    service.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                // Selection indicator
                if (isSelected) const Icon(Icons.check_circle, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
