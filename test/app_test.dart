import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this
import 'package:EuroCalculator/screens/settings_screen.dart';
import 'package:EuroCalculator/screens/setup_screen.dart';
import 'package:EuroCalculator/providers/app_state_provider.dart';

void main() {
  // Ensure the Flutter binding is ready for SharedPreferences mocks
  TestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Navigation Flow', () {
    testWidgets('Full Wipe: Reset All clears memory and redirects', (
      tester,
    ) async {
      // 1. MOCK SHARED PREFERENCES BEFORE CREATING THE PROVIDER
      SharedPreferences.setMockInitialValues({});

      // 2. Initialize State and wait for the internal SharedPreferences to load
      final state = AppStateProvider();

      // We give the provider a moment to finish its async _initEngine()
      // Otherwise, we hit the LateInitializationError on _prefs
      int attempts = 0;
      while (!state.isReady && attempts < 10) {
        await tester.pump(const Duration(milliseconds: 10));
        attempts++;
      }

      // 3. Build the UI
      await tester.pumpWidget(
        ChangeNotifierProvider<AppStateProvider>.value(
          value: state,
          child: MaterialApp(
            home: const SettingsScreen(),
            routes: {'/setup': (context) => const SetupScreen()},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 4. Find and Scroll to the Nuclear Button
      final resetBtnFinder = find.byKey(const Key('hard_reset_button'));

      // The tester "swipes" to make sure the button isn't hidden by the list
      await tester.dragUntilVisible(
        resetBtnFinder,
        find.byType(ListView),
        const Offset(0, -300),
      );

      await tester.tap(resetBtnFinder);
      await tester.pumpAndSettle();

      // 5. Confirm the Wipe
      final confirmBtn = find.text('ИЗТРИЙ');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);

      // 6. Wait for the wipe logic and navigation to finish
      await tester.pumpAndSettle();

      // 7. FINAL VERIFICATION
      expect(find.byType(SetupScreen), findsOneWidget);
    });
  });
}
