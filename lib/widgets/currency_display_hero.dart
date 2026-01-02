import 'package:EuroCalculator/core/app_theme.dart';
import 'package:flutter/material.dart';


class CurrencyDisplayHero extends StatelessWidget {
  final double euroAmount;
  final double levAmount;

  const CurrencyDisplayHero({
    super.key,
    required this.euroAmount,
    required this.levAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          child: Text(
            "${euroAmount.toStringAsFixed(2)} €",
            style: const TextStyle(
              color: AppTheme.piggyPink,
              fontSize: 80,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "РЕСТО: ${levAmount.toStringAsFixed(2)} лв",
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
