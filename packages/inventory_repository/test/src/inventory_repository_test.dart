// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_repository/inventory_repository.dart';

void main() {
  group('InventoryRepository', () {
    test('can be instantiated', () {
      expect(InventoryRepository(), isNotNull);
    });
  });
}
