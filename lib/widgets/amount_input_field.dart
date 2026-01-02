// lib/widgets/amount_input_field.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/app_state_provider.dart';
import '../core/haptic_service.dart'; // Ensure this matches your file path

class AmountInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final Color accentColor;
  final bool isDarkMode;

  const AmountInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.accentColor,
    required this.isDarkMode,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final normalizedLabel = label.toUpperCase().trim();

    // Logic to determine which field we are dealing with
    final bool isBillField =
        normalizedLabel.contains("СМЕТКА") || normalizedLabel.contains("ОБЩО");
    final bool isReceivedField =
        normalizedLabel.contains("ПОЛУЧЕНО") ||
        normalizedLabel.contains("ВЗЕТО") ||
        normalizedLabel.contains("ДАВАМ");

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.blue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.blue.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            readOnly: readOnly,
            onChanged: (value) {
              HapticService.light();
              state.refresh();
            },
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            cursorColor: accentColor,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: "0.00",
              hintStyle: TextStyle(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.3),
              ),
              // We only show the toggle if it's one of our recognized fields
              suffixIcon: (isBillField || isReceivedField)
                  ? _buildToggle(state, isBillField, isReceivedField)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(AppStateProvider state, bool isBill, bool isReceived) {
    bool isEuro = false;
    VoidCallback? toggleAction;

    if (isBill) {
      isEuro = state.billInEuro;
      toggleAction = state.toggleBillCurrency;
    } else if (isReceived) {
      isEuro = state.isReceivedInEuro;
      toggleAction = state.toggleReceivedCurrency;
    }

    return TextButton(
      onPressed: () {
        HapticService.selection(); // Distinct feel for changing currency
        toggleAction?.call();
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        backgroundColor: accentColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        isEuro ? "EUR" : "BGN",
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}
