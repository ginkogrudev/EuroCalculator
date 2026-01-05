import 'package:EuroCalculator/core/haptic_service.dart';
import 'package:EuroCalculator/providers/app_state_provider.dart';
import 'package:flutter/material.dart';

enum PickerType { accent, background, text }

void showPiggyColorPicker(BuildContext context, AppStateProvider state) {
  showModalBottomSheet(
    context: context,
    backgroundColor: state.bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: state.textColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            _pickerLabel("ЦВЯТ НА АКЦЕНТА", state.accentColor),
            const SizedBox(height: 12),
            _buildColorRow(state, PickerType.accent),

            const SizedBox(height: 24),

            _pickerLabel("ЦВЯТ НА ФОНА", state.textColor),
            const SizedBox(height: 12),
            _buildColorRow(state, PickerType.background),

            const SizedBox(height: 24),

            _pickerLabel("ЦВЯТ НА ТЕКСТА", state.textColor),
            const SizedBox(height: 12),
            _buildColorRow(state, PickerType.text),

            const SizedBox(height: 20),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                state.resetTheme();
                HapticService.heavy(); // Feedback that a big change happened
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: state.textColor.withValues(alpha: 0.1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "ВЪРНИ СТАНДАРТНИТЕ ЦВЕТОВЕ",
                style: TextStyle(
                  color: state.textColor.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildColorRow(AppStateProvider state, PickerType type) {
  final List<Color> options;
  if (type == PickerType.accent) {
    options = [
      const Color(0xFFFF2D55),
      const Color(0xFF007AFF),
      const Color(0xFF5856D6),
      const Color(0xFF32D74B),
      const Color(0xFFFF9500),
    ];
  } else if (type == PickerType.background) {
    options = [
      const Color(0xFF000000),
      const Color(0xFF1A1A1A),
      const Color(0xFF0D1117),
      const Color(0xFFFFFFFF),
      const Color(0xFFF2F2F7),
    ];
  } else {
    options = [
      Colors.white,
      Colors.black,
      const Color(0xFFFFD1DC),
      const Color(0xFF8E8E93),
    ];
  }

  return Wrap(
    spacing: 12,
    children: options.map((color) => _colorBubble(state, color, type)).toList(),
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

Widget _colorBubble(AppStateProvider state, Color color, PickerType type) {
  bool isSelected;
  switch (type) {
    case PickerType.accent:
      isSelected = state.accentColor.toARGB32() == color.toARGB32();
      break;
    case PickerType.background:
      isSelected = state.bgColor.toARGB32() == color.toARGB32();
      break;
    case PickerType.text:
      isSelected = state.textColor.toARGB32() == color.toARGB32();
      break;
  }

  return GestureDetector(
    onTap: () {
      if (type == PickerType.accent) {
        HapticService.light();
        state.updateAccentColor(color);
      }
      if (type == PickerType.background) {
        HapticService.light();
        state.updateBgColor(color);
      }
      if (type == PickerType.text) {
        HapticService.light();
        state.updateTextColor(color);
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
          color: isSelected ? state.accentColor : Colors.white10,
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
