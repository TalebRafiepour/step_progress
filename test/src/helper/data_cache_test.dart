import 'package:flutter_test/flutter_test.dart';
import 'package:step_progress/src/helpers/data_cache.dart';

void main() {
  group('DataCache', () {
    group('Singleton Pattern', () {
      test('should return same instance when created multiple times', () {
        final instance1 = DataCache();
        final instance2 = DataCache();
        expect(identical(instance1, instance2), true);
      });
    });

    group('Data Operations', () {
      late DataCache cache;

      setUp(() {
        cache = DataCache()..clearCache();
      });

      test('should store and retrieve data correctly', () {
        const testKey = 'test-key';
        const testValue = 'test-value';

        cache.setData(testKey, testValue);
        expect(cache.getData(testKey), equals(testValue));
      });

      test('should return null for non-existent key', () {
        expect(cache.getData('non-existent-key'), isNull);
      });

      test('should overwrite existing data with same key', () {
        const testKey = 'test-key';
        const initialValue = 'initial-value';
        const newValue = 'new-value';

        cache
          ..setData(testKey, initialValue)
          ..setData(testKey, newValue);
        expect(cache.getData(testKey), equals(newValue));
      });

      test('should store different types of data', () {
        cache
          ..setData('string', 'string-value')
          ..setData('int', 42)
          ..setData('bool', true)
          ..setData('list', [1, 2, 3])
          ..setData('map', {'key': 'value'});

        expect(cache.getData('string'), isA<String>());
        expect(cache.getData('int'), isA<int>());
        expect(cache.getData('bool'), isA<bool>());
        expect(cache.getData('list'), isA<List>());
        expect(cache.getData('map'), isA<Map>());
      });
    });

    group('Cache Clearing', () {
      late DataCache cache;

      setUp(() {
        cache = DataCache();
      });

      test('should clear all stored data', () {
        cache
          ..setData('key1', 'value1')
          ..setData('key2', 'value2')
          ..clearCache();

        expect(cache.getData('key1'), isNull);
        expect(cache.getData('key2'), isNull);
      });

      test('should be able to store data after clearing', () {
        cache
          ..setData('key1', 'value1')
          ..clearCache();

        const newKey = 'new-key';
        const newValue = 'new-value';
        cache.setData(newKey, newValue);

        expect(cache.getData(newKey), equals(newValue));
      });
    });

    group('DataCacheKey', () {
      test('should have correct constant values', () {
        expect(DataCacheKey.lineWidgetSize, equals('line-widget-size'));
        expect(DataCacheKey.lineWidgetPosition, equals('line-widget-position'));
        expect(DataCacheKey.wholeWidgetSize, equals('whole-widget-size'));
      });

      test('should work with DataCache operations', () {
        final cache = DataCache()
          ..setData(DataCacheKey.lineWidgetSize, 100)
          ..setData(DataCacheKey.lineWidgetPosition, {'x': 0, 'y': 0})
          ..setData(DataCacheKey.wholeWidgetSize, {
            'width': 200,
            'height': 300,
          });

        expect(cache.getData(DataCacheKey.lineWidgetSize), equals(100));
        expect(
          cache.getData(DataCacheKey.lineWidgetPosition),
          equals({'x': 0, 'y': 0}),
        );
        expect(
          cache.getData(DataCacheKey.wholeWidgetSize),
          equals({'width': 200, 'height': 300}),
        );
      });
    });
  });
}
