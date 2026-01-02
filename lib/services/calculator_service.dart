import '../core/constants.dart';

class CalculatorService {
  String formatCurrency(double amount) => amount.toStringAsFixed(2);

  /// Calculates change in BGN, regardless of input currencies
  double calculateChangeBgn({
    required double billAmount,
    required bool billInEuro,
    required double receivedAmount,
    required bool receivedInEuro,
  }) {
    // 1. SANITIZE: Treat negative inputs as 0.0
    final bill = billAmount < 0 ? 0.0 : billAmount;
    final received = receivedAmount < 0 ? 0.0 : receivedAmount;

    // 2. Normalize Bill to BGN
    double normalizedBill = billInEuro ? bill * AppConstants.eurRate : bill;

    // 3. Normalize Received to BGN
    double normalizedReceived = receivedInEuro
        ? received * AppConstants.eurRate
        : received;

    // 4. Calculate Difference
    double result = normalizedReceived - normalizedBill;

    // 5. Final Safety: Return 0.0 if not enough money was given
    return result < 0 ? 0.0 : result;
  }

  /// Helper to get the EUR display value from a BGN base
  double convertToEur(double bgnAmount) {
    if (bgnAmount <= 0) return 0.0;
    return bgnAmount / AppConstants.eurRate;
  }
}
