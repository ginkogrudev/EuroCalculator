import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:EuroCalculator/providers/app_state_provider.dart';

class CurrencyHeroResto extends StatelessWidget {
  final double restoBgn;
  final double restoEuro;

  const CurrencyHeroResto({
    super.key,
    required this.restoBgn,
    required this.restoEuro,
  });

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            "РЕСТО",
            style: TextStyle(
              color: state.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "${restoEuro.toStringAsFixed(2)} €",
                style: TextStyle(
                  color: state.accentColor, // The User's Picked Branded Color
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "≈",
                  style: TextStyle(
                    color: state.textColor.withValues(alpha: .2),
                    fontSize: 24,
                  ),
                ),
              ),
              Text(
                "${restoBgn.toStringAsFixed(2)} лв",
                style: TextStyle(
                  color: state.textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
