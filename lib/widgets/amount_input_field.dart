// lib/widgets/amount_input_field.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'package:flutter/services.dart';

class AmountInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color accentColor;
  final bool isBillField;

  const AmountInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.accentColor,
    this.isBillField = true,
  });

  @override
  Widget build(BuildContext context) {
    // Watch the state so the widget rebuilds when theme changes
    final state = context.watch<AppStateProvider>();
    final textColor = state.textColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: accentColor,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          TextField(
            controller: controller,
            readOnly: false,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),

            // --- THE GATEKEEPER: Numbers Only & Max 2 Decimals ---
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],

            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            cursorColor: accentColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: "0.00",
              hintStyle: TextStyle(color: textColor.withValues(alpha: 0.2)),
              suffixIcon: _buildCurrencyToggle(state),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyToggle(AppStateProvider state) {
    bool isEuro = isBillField ? state.billInEuro : state.isReceivedInEuro;
    return GestureDetector(
      onTap: isBillField
          ? state.toggleBillCurrency
          : state.toggleReceivedCurrency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isEuro ? "EUR" : "BGN",
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w900, // Thicker font for the toggle
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
