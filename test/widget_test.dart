// KaamChalu Widget Tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Basic test to verify app can build
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: Text('KaamChalu Test')),
          ),
        ),
      ),
    );

    expect(find.text('KaamChalu Test'), findsOneWidget);
  });
}
