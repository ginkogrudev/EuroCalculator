import 'package:flutter_test/flutter_test.dart';
import 'package:EuroCalculator/services/calculator_service.dart';

void main() {
  final calculator = CalculatorService();
  const double eurRate = 1.95583; // Tracking the core constant

  group('Core Currency Conversion Logic', () {
    test('Identical values in different currencies (Exact Rate Check)', () {
      // 100 EUR vs 195.583 BGN should result in 0.00 change
      final change = calculator.calculateChangeBgn(
        billAmount: 100.0 * eurRate,
        billInEuro: false,
        receivedAmount: 100.0,
        receivedInEuro: true,
      );
      expect(calculator.formatCurrency(change), "0.00");
    });

    test('BGN Bill paid with EUR (The most common tourist case)', () {
      // 50 BGN bill paid with 30 EUR (30 * 1.95583 = 58.6749)
      // Change: 58.6749 - 50.00 = 8.6749
      final change = calculator.calculateChangeBgn(
        billAmount: 50.0,
        billInEuro: false,
        receivedAmount: 30.0,
        receivedInEuro: true,
      );
      expect(calculator.formatCurrency(change), "8.67");
    });

    test('EUR Bill paid with BGN (The business case)', () {
      // 20 EUR bill (39.1166 BGN) paid with 50 BGN
      // Change: 50.00 - 39.1166 = 10.8834
      final change = calculator.calculateChangeBgn(
        billAmount: 20.0,
        billInEuro: true,
        receivedAmount: 50.0,
        receivedInEuro: false,
      );
      expect(calculator.formatCurrency(change), "10.88");
    });
  });

  group('Safety & Error Handling', () {
    test('Received amount exactly equals bill (No change)', () {
      final change = calculator.calculateChangeBgn(
        billAmount: 125.50,
        billInEuro: false,
        receivedAmount: 125.50,
        receivedInEuro: false,
      );
      expect(change, 0.0);
    });

    test('Insufficient funds should ALWAYS return 0.0', () {
      final change = calculator.calculateChangeBgn(
        billAmount: 1000.0,
        billInEuro: false,
        receivedAmount: 10.0,
        receivedInEuro: false,
      );
      expect(change, 0.0);
    });

    test('Handles extremely large numbers (Store stress test)', () {
      final change = calculator.calculateChangeBgn(
        billAmount: 999999.99,
        billInEuro: false,
        receivedAmount: 2000000.00,
        receivedInEuro: false,
      );
      expect(change, 1000000.01);
    });
  });

  group('Rounding & Precision (Stotinka Safety)', () {
    test('Very small difference (Micro-change check)', () {
      // 10.00 BGN paid with 10.004 BGN should not show 0.01
      final change = calculator.calculateChangeBgn(
        billAmount: 10.00,
        billInEuro: false,
        receivedAmount: 10.004,
        receivedInEuro: false,
      );
      expect(calculator.formatCurrency(change), "0.00");
    });

    test('Conversion rounding alignment', () {
      // 1.95 BGN converted to Euro should be 0.997... formatted to 1.00 or 0.99
      final bgnChange = 1.95;
      final eurChange = calculator.convertToEur(bgnChange);
      // 1.95 / 1.95583 = 0.9970
      expect(eurChange.toStringAsFixed(2), "1.00");
    });
  });
}
