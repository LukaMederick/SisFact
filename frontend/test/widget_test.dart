import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('SisFactApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SisFactApp());
    expect(find.byType(SisFactApp), findsOneWidget);
  });
}
