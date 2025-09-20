// Not required for test files

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationRepository', () {
    test('can be instantiated', () {
      expect(AuthenticationRepository(), isNotNull);
    });
  });
}
