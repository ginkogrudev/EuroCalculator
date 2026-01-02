// lib/widgets/settings/color_picker_sheet.dart
import 'package:EuroCalculator/providers/app_state_provider.dart';
import 'package:flutter/material.dart';

void showPiggyColorPicker(BuildContext context, AppStateProvider state) {
  showModalBottomSheet(
    context: context,
    backgroundColor: state.bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return StatefulBuilder(
        // Use StatefulBuilder for immediate UI feedback in the sheet
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // SECTION 1: ACCENT COLORS
                _pickerLabel("ЦВЯТ НА АКЦЕНТА", state.accentColor),
                const SizedBox(height: 16),
                _buildColorRow(state, isAccent: true),

                const SizedBox(height: 32),

                // SECTION 2: BACKGROUND COLORS
                _pickerLabel("ЦВЯТ НА ФОНА", Colors.white38),
                const SizedBox(height: 16),
                _buildColorRow(state, isAccent: false),

                const SizedBox(height: 30),

                // LIVE CODE BOX
                _buildCodePreview(state),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _pickerLabel(String text, Color color) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: FontWeight.w900,
      fontSize: 10,
      letterSpacing: 1.5,
    ),
  );
}

Widget _buildColorRow(AppStateProvider state, {required bool isAccent}) {
  final List<Color> accentOptions = [
    const Color(0xFFFF2D55), // Piggy Pink
    const Color(0xFF007AFF), // Electric Blue
    const Color(0xFF5856D6), // Royal Purple
    const Color(0xFF32D74B), // Cash Green
    const Color(0xFFFF9500), // Gold
  ];

  final List<Color> bgOptions = [
    const Color(0xFF000000), // Pure Black
    const Color(0xFF1A1A1A), // Soft Dark
    const Color(0xFF0D1117), // Deep Navy
    const Color(0xFFFFFFFF), // Clean White
    const Color(0xFFF2F2F7), // iOS Light Grey
  ];

  return Wrap(
    spacing: 12,
    children: (isAccent ? accentOptions : bgOptions).map((color) {
      return _colorBubble(state, color, isAccent);
    }).toList(),
  );
}

Widget _colorBubble(AppStateProvider state, Color color, bool isAccent) {
  bool isSelected = isAccent
      ? state.accentColor.toARGB32() == color.toARGB32
      : state.bgColor.toARGB32 == color.toARGB32;

  return GestureDetector(
    onTap: () {
      if (isAccent) {
        state.updateAccentColor(color);
      } else {
        state.updateBgColor(color);
      }
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? (color.computeLuminance() > 0.5 ? Colors.black : Colors.white)
              : Colors.white10,
          width: isSelected ? 3 : 1,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: 20,
              color: color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
            )
          : null,
    ),
  );
}

Widget _buildCodePreview(AppStateProvider state) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 50),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "ВАШИЯТ КОД:",
          style: TextStyle(color: Colors.white38, fontSize: 10),
        ),
        SelectableText(
          state.shareableThemeCode,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    ),
  );
}
