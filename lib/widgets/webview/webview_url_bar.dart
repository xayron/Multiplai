import 'package:flutter/material.dart';

class WebviewUrlBar extends StatelessWidget {
  final String currentUrl;
  final bool isLoading;
  final VoidCallback onRefresh;

  const WebviewUrlBar({
    super.key,
    required this.currentUrl,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outline.withAlpha((0.2 * 255).toInt()),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Reset button
          InkWell(
            onTap: onRefresh,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.refresh,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.lock_outline,
            size: 16,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              currentUrl,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.8 * 255).toInt()),
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}
