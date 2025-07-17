import 'package:flutter/material.dart';
import 'package:multiplai/services/cache_service.dart';

class CacheManager extends StatefulWidget {
  final String serviceName;

  const CacheManager({super.key, required this.serviceName});

  @override
  State<CacheManager> createState() => _CacheManagerState();
}

class _CacheManagerState extends State<CacheManager> {
  int _cacheSize = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    setState(() {
      _isLoading = true;
    });

    final size = await CacheService.getServiceCacheSize(widget.serviceName);

    if (mounted) {
      setState(() {
        _cacheSize = size;
        _isLoading = false;
      });
    }
  }

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: Text(
          'Are you sure you want to clear the cache for ${widget.serviceName}? '
          'This will log you out and remove all saved data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      await CacheService.clearServiceCache(widget.serviceName);
      await _loadCacheSize();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cache cleared for ${widget.serviceName}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storage,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.6 * 10).toInt()),
              ),
              const SizedBox(width: 8),
              Text(
                'Cache',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              CacheService.formatBytes(_cacheSize),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.7 * 10).toInt()),
                fontFamily: 'monospace',
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _cacheSize > 0 ? _clearCache : null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: const Size(0, 32),
              ),
              child: const Text('Clear Cache', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
