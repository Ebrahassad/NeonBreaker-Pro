import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NeonBreaker starts', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('NEONBREAKER'))),
    );

    expect(find.text('NEONBREAKER'), findsOneWidget);
  });
}
