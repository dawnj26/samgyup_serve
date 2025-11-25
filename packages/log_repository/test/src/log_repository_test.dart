// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:log_repository/log_repository.dart';

void main() {
  group('LogRepository', () {
    test('can be instantiated', () {
      expect(LogRepository(), isNotNull);
    });
  });
}
