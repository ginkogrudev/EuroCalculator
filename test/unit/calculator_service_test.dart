// test/unit/calculator_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:EuroCalculator/services/calculator_service.dart';

void main() {
  final calculator = CalculatorService();

  group('Cross-Currency Logic Tests', () {
    test('Scenario: BGN Bill (20.00) paid with EUR (10.00)', () {
      // 10 EUR at 1.95583 = 19.5583 BGN.
      // Result should be 0 because 19.55 < 20.00 (Insufficient funds)
      final change = calculator.calculateChangeBgn(
        billAmount: 20.0,
        billInEuro: false,
        receivedAmount: 10.0,
        receivedInEuro: true,
      );
      expect(change, 0.0);
    });

    test('Scenario: BGN Bill (10.00) paid with EUR (10.00)', () {
      // 10 EUR = 19.5583 BGN. Change = 19.5583 - 10.00 = 9.5583
      final change = calculator.calculateChangeBgn(
        billAmount: 10.0,
        billInEuro: false,
        receivedAmount: 10.0,
        receivedInEuro: true,
      );
      expect(change, closeTo(9.5583, 0.0001));
    });

    test('Scenario: EUR Bill paid with EUR (Pure Euro Mode)', () {
      // 50.00 EUR bill paid with 100.00 EUR
      // Change should be 50 EUR * 1.95583 = 97.7915 BGN
      final change = calculator.calculateChangeBgn(
        billAmount: 50.0,
        billInEuro: true,
        receivedAmount: 100.0,
        receivedInEuro: true,
      );
      expect(change, closeTo(97.7915, 0.0001));
    });
  });

  group('Edge Case Math & Precision', () {
    test('Handle Zero & Negative Inputs Gracefully', () {
      final change = calculator.calculateChangeBgn(
        billAmount: -50.0,
        billInEuro: false,
        receivedAmount: 0.0,
        receivedInEuro: false,
      );
      expect(change, 0.0);
    });

    test('Precision Test: Floating point rounding (The 0.01 bug)', () {
      // 1 EUR = 1.95583 BGN.
      final change = calculator.calculateChangeBgn(
        billAmount: 1.00,
        billInEuro: true,
        receivedAmount: 1.96,
        receivedInEuro: false,
      );

      // Real change is 0.00417.
      // In currency, this is effectively zero because it's less than half a stotinka.
      expect(calculator.formatCurrency(change), "0.00");
    });

    test('Precision Test: 100 EUR exact check', () {
      // 100 EUR is exactly 195.583 BGN
      final changeBgn = calculator.calculateChangeBgn(
        billAmount: 0.0,
        billInEuro: false,
        receivedAmount: 100.0,
        receivedInEuro: true,
      );

      // Should format to 195.58 BGN (standard Bulgarian bank rounding/truncation)
      expect(calculator.formatCurrency(changeBgn), "195.58");
    });
  });
}
