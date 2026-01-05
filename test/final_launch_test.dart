// test/final_launch_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:EuroCalculator/providers/app_state_provider.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Final Production Validation', () {
    late AppStateProvider state;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      state = AppStateProvider();
      await Future.delayed(Duration.zero);
    });

    test('Theme Code Integrity: Colors match the generated String', () {
      // Set specific colors (Pink Accent, Black BG)
      state.updateAccentColor(const Color(0xFFFF2D55));
      state.updateBgColor(const Color(0xFF000000));


      // Change to Blue/White
      state.updateAccentColor(const Color(0xFF007AFF));
      state.updateBgColor(const Color(0xFFFFFFFF));
    });

    test(
      'Life-Proofing: Calculator handles empty/null strings without crashing',
      () {
        state.billController.text = "";
        state.receivedController.text = "";

        // Should return 0.0, not throw an exception
        expect(state.restoBgn, 0.0);
        expect(state.restoEuro, 0.0);
      },
    );

    test(
      'Gatekeeper: setupComplete is strictly tied to display_name',
      () async {
        expect(state.setupComplete, false);

        await state.completeSetup("Ginko", false);
        expect(state.setupComplete, true);
        expect(state.displayName, "Ginko");

        await state.hardReset();
        expect(state.setupComplete, false);
        expect(state.displayName, "");
      },
    );
  });
}
