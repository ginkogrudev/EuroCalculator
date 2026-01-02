import 'package:EuroCalculator/core/app_theme.dart';
import 'package:flutter/material.dart';

class TransactionInputTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isActive;
  final VoidCallback onTap;

  const TransactionInputTile({
    super.key,
    required this.label,
    required this.value,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.heroBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isActive ? AppTheme.piggyPink : AppTheme.heroBlue,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppTheme.piggyPink : Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  "${value.isEmpty ? '0.00' : value} лв",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalcButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const CalcButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.white.withValues(alpha: 0.5),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
