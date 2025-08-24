// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:cache_repository/cache_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CacheRepository', () {
    test('can be instantiated', () {
      expect(CacheRepository(), isNotNull);
    });
  });
}
