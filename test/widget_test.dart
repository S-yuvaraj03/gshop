import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('Basic widget test', (WidgetTester tester) async {
      // Build test widget
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Text('Test'),
        ),
      ));

      // Verify widget renders
      expect(find.text('Test'), findsOneWidget);
    });

    test('Basic unit test', () {
      expect(2 + 2, equals(4));
    });

    testWidgets('Tap test', (WidgetTester tester) async {
      int counter = 0;
      
      await tester.pumpWidget(MaterialApp(
        home: GestureDetector(
          onTap: () => counter++,
          child: const Text('Tap me'),
        ),
      ));

      await tester.tap(find.text('Tap me'));
      expect(counter, 1);
    });
  });
}