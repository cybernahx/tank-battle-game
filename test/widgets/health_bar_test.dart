import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tank_game/widgets/health_bar.dart';

void main() {
  group('HealthBar Widget', () {
    testWidgets('displays correct number of filled hearts', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HealthBar(health: 2, maxHealth: 3),
          ),
        ),
      );

      // Find filled hearts (favorite icon)
      final filledHearts = find.byIcon(Icons.favorite);
      expect(filledHearts, findsNWidgets(2));

      // Find empty hearts (favorite_border icon)
      final emptyHearts = find.byIcon(Icons.favorite_border);
      expect(emptyHearts, findsNWidgets(1));
    });

    testWidgets('displays all empty hearts when health is 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HealthBar(health: 0, maxHealth: 3),
          ),
        ),
      );

      final emptyHearts = find.byIcon(Icons.favorite_border);
      expect(emptyHearts, findsNWidgets(3));
    });

    testWidgets('displays all filled hearts when health is max', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HealthBar(health: 3, maxHealth: 3),
          ),
        ),
      );

      final filledHearts = find.byIcon(Icons.favorite);
      expect(filledHearts, findsNWidgets(3));
    });
  });
}
