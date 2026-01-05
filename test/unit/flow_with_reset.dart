import 'package:EuroCalculator/providers/app_state_provider.dart';
import 'package:EuroCalculator/screens/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Mandatory for mock plugins
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full Setup Flow: Selecting Business updates Home labels', (
    WidgetTester tester,
  ) async {
    // 2. Setup the mock BEFORE anything else
    SharedPreferences.setMockInitialValues({});

    final appState = AppStateProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppStateProvider>.value(
        value: appState,
        child: const MaterialApp(home: SetupScreen()),
      ),
    );

    // 4. Perform actions
    await tester.enterText(find.byType(TextField), 'Piggy Owner');
    await tester.pump(); // Ensure text is registered

    await tester.tap(find.text('БИЗНЕС'));
    await tester.pump();

    // 5. Tap the CTA
    await tester.tap(find.text('ЗАПОЧНИ ДА СМЯТАШ'));

    // 6. pumpAndSettle is critical here to wait for the Navigator transition
    await tester.pumpAndSettle();

    // 7. Verify the results
    expect(find.text('ПОЛУЧЕНИ ПАРИ'), findsOneWidget);
    expect(find.text('ДАДЕНИ ПАРИ'), findsNothing);
  });
}
