import 'package:EuroCalculator/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget build(BuildContext context) {
  final state = context.watch<AppStateProvider>();

  return Container(
    // Minimum vertical padding to keep it tight
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "PECTO",
          style: TextStyle(
            color: state.textColor.withValues(alpha: 0.5),
            fontSize: 10, // Slightly smaller label
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        // Minimal gap between label and numbers
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "${state.restoEuro.toStringAsFixed(2)} €",
                style: TextStyle(
                  color: state.accentColor,
                  fontSize:
                      48, // Large enough to be "Hero", small enough to fit
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "≈",
                style: TextStyle(
                  color: state.textColor.withValues(alpha: 0.3),
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${state.restoBgn.toStringAsFixed(2)} лв",
                style: TextStyle(
                  color: state.textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
