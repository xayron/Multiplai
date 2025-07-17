import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class CacheService {
  static const String _cacheBaseDir = 'webview_cache';

  /// Get the cache directory for a specific service
  static Future<String> getServiceCachePath(String serviceName) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDocDir.path}/$_cacheBaseDir/$serviceName');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    return cacheDir.path;
  }

  /// Clear cache for a specific service
  static Future<void> clearServiceCache(String serviceName) async {
    try {
      final cachePath = await getServiceCachePath(serviceName);
      final cacheDir = Directory(cachePath);

      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing cache for $serviceName: $e');
    }
  }

  /// Clear all service caches
  static Future<void> clearAllCaches() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final baseCacheDir = Directory('${appDocDir.path}/$_cacheBaseDir');

      if (await baseCacheDir.exists()) {
        await baseCacheDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing all caches: $e');
    }
  }

  /// Get cache size for a specific service
  static Future<int> getServiceCacheSize(String serviceName) async {
    try {
      final cachePath = await getServiceCachePath(serviceName);
      final cacheDir = Directory(cachePath);

      if (!await cacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize;
    } catch (e) {
      print('Error getting cache size for $serviceName: $e');
      return 0;
    }
  }

  /// Get total cache size for all services
  static Future<int> getTotalCacheSize() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final baseCacheDir = Directory('${appDocDir.path}/$_cacheBaseDir');

      if (!await baseCacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in baseCacheDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize;
    } catch (e) {
      print('Error getting total cache size: $e');
      return 0;
    }
  }

  /// Format bytes to human readable format
  static String formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (log(bytes) / log(1024)).floor();

    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}
