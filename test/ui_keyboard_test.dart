import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:EuroCalculator/screens/home_view.dart';
import 'package:provider/provider.dart';
import 'package:EuroCalculator/providers/app_state_provider.dart';

void main() {
  testWidgets('Keyboard should not cause overflow in HomeView', (
    WidgetTester tester,
  ) async {
    // 1. Setup the state
    final appState = AppStateProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(home: HomeView()),
      ),
    );

    // 2. Simulate opening the keyboard
    // We do this by reducing the vertical height of the screen
    await tester.binding.setSurfaceSize(const Size(400, 400));
    await tester.pump();

    // 3. Verify that the input fields are still in the tree and not "overflowing"
    // Flutter throws a 'render overflow' exception if the UI breaks.
    // If this test finishes without error, your layout is safe!
    expect(find.byType(TextField), findsNWidgets(2));

    // Reset size
    await tester.binding.setSurfaceSize(null);
  });
}
