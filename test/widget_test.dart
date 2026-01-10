import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tank_game/screens/main_menu_screen.dart';

void main() {
  testWidgets('MainMenuScreen renders title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MainMenuScreen()),
    );
    await tester.pump();

    // Verify that the title text is present
    expect(find.text('TANK BATTLE'), findsOneWidget);
  });
}
