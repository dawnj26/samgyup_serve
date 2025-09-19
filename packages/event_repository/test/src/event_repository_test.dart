// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:event_repository/event_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventRepository', () {
    test('can be instantiated', () {
      expect(EventRepository(), isNotNull);
    });
  });
}
