// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:table_repository/table_repository.dart';

void main() {
  group('TableRepository', () {
    test('can be instantiated', () {
      expect(TableRepository(), isNotNull);
    });
  });
}
