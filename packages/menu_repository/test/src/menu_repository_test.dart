// Not required for test files

import 'package:flutter_test/flutter_test.dart';
import 'package:menu_repository/menu_repository.dart';

void main() {
  group('MenuRepository', () {
    test('can be instantiated', () {
      expect(MenuRepository(), isNotNull);
    });
  });
}
