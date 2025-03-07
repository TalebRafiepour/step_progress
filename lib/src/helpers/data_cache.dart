/// A class that provides caching functionality for data.
///
/// This class can be used to store and retrieve data efficiently,
/// reducing the need for repeated data fetching operations.
class DataCache {
  /// Factory constructor to return the singleton instance of DataCache.
  factory DataCache() => _instance;

  /// Private named constructor for internal use.
  DataCache._internal();

  /// Singleton instance of DataCache.
  static final DataCache _instance = DataCache._internal();

  /// Internal cache storage.
  final Map<String, dynamic> _cache = {};

  /// Retrieves data from the cache by key.
  dynamic getData(String key) => _cache[key];

  /// Sets data in the cache with the specified key.
  void setData(String key, Object value) => _cache[key] = value;

  /// Clears all data in the cache.
  void clearCache() {
    _cache.clear();
  }
}

/// An abstract class that represents a key for data caching.
///
/// This class is intended to be extended by other classes that define
/// specific keys for caching data. It provides a common interface for
/// all cache keys, ensuring consistency and type safety.
abstract class DataCacheKey {
  static const String lineWidgetSize = 'line-widget-size';
  static const String lineWidgetPosition = 'line-widget-position';
  static const String wholeWidgetSize = 'whole-widget-size';
}
