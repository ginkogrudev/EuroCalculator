// test/app_state_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:EuroCalculator/providers/app_state_provider.dart';
import 'package:flutter/material.dart';

void main() {
  // 1. Necessary for any test that uses SharedPreferences or Controllers
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppStateProvider Logic Tests', () {
    late AppStateProvider state;

    setUp(() async {
      // Initialize mocks BEFORE creating the provider
      SharedPreferences.setMockInitialValues({});
      state = AppStateProvider();

      // 2. Wait for the engine to be 'ready'
      // We loop briefly until the internal init finishes
      int retry = 0;
      while (!state.isReady && retry < 10) {
        await Future.delayed(const Duration(milliseconds: 10));
        retry++;
      }
    });

    test('Initial state should be personal with piggy pink', () {
      expect(state.setupComplete, false);
      // Using .value to compare the exact integer of the color
      expect(state.accentColor.toARGB32(), const Color(0xFFFF2D55).toARGB32());
    });

    test('Math: Calculate change correctly (BGN to BGN)', () {
      state.billController.text = "10.00";
      state.receivedController.text = "20.00";

      // 20.00 - 10.00 = 10.0
      expect(state.changeInLev, 10.0);
    });

    test('Math: Calculate change correctly (BGN Bill, EUR Received)', () {
      state.billController.text = "1.96";
      state.toggleReceivedCurrency(); // Switch to Euro
      state.receivedController.text = "1.00";

      // (1.00 * 1.95583) - 1.96 = -0.00417...
      // closeTo(0, 0.01) allows for this tiny rounding difference
      expect(state.changeInLev, closeTo(0, 0.01));
    });

    test('Theme: applyThemeCode ignores invalid formats', () {
      final initialColor = state.accentColor;

      state.applyThemeCode("INVALID-CODE");
      state.applyThemeCode("123-456"); // Too short

      expect(state.accentColor, initialColor);
    });

    test('Theme: applyThemeCode applies valid 6-char hex', () {
      state.applyThemeCode("00FF00-FFFFFF"); // Green accent, White BG

      // Call the method on both to compare the resulting integers
      expect(state.accentColor.toARGB32(), const Color(0xFF00FF00).toARGB32());
      expect(state.bgColor.toARGB32(), const Color(0xFFFFFFFF).toARGB32());
    });

    test('Reset: hardReset clears all data', () async {
      await state.completeSetup("Ginko", false);
      await state.hardReset();

      expect(state.setupComplete, false);
      expect(state.displayName, "");
      // Compare to Piggy Pink using the modern method
      expect(state.accentColor.toARGB32(), const Color(0xFFFF2D55).toARGB32());
    });
  });
}
