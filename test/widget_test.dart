import 'package:flutter_test/flutter_test.dart';
import 'package:activity05_counter/main.dart';

void main() {
  testWidgets('Activity 05 Counter loads', (WidgetTester tester) async {
    await tester.pumpWidget(const CounterApp());

    expect(find.text('Activity 05 Counter'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
  });
}