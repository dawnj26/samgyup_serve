import 'package:flutter_test/flutter_test.dart';
import 'package:samgyup_serve/app/app.dart';
import 'package:samgyup_serve/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
