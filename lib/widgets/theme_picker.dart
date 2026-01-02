import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/app_state_provider.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

  // Helper to get clean 6-digit hex string safely
  String _colorToHex(Color c) =>
      c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    final List<Color> accentOptions = [
      AppTheme.piggyPink,
      AppTheme.heroBlue,
      const Color(0xFFBF5AF2),
      const Color(0xFF64D2FF),
    ];

    final List<Color> bgOptions = [
      AppTheme.darkBg,
      AppTheme.lightBg,
      const Color(0xFF1C1C1E),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("ACCENT COLOR"),
        const SizedBox(height: 12),
        _buildColorRow(accentOptions, state.accentColor, (color) {
          final accent = _colorToHex(color);
          final bg = _colorToHex(state.bgColor);
          state.applyThemeCode("$accent-$bg");
        }),

        const SizedBox(height: 24),

        _buildLabel("BACKGROUND"),
        const SizedBox(height: 12),
        _buildColorRow(bgOptions, state.bgColor, (color) {
          final accent = _colorToHex(state.accentColor);
          final bg = _colorToHex(color);
          state.applyThemeCode("$accent-$bg");
        }),

        const SizedBox(height: 32),
        _buildShareCodeSection(context, state),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Colors.white38,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildColorRow(
    List<Color> colors,
    Color current,
    Function(Color) onSelect,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        // Correctly compare using the method call
        final bool isSelected = current.toARGB32() == color.toARGB32();

        return GestureDetector(
          onTap: () => onSelect(color),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white10,
                width: 3,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShareCodeSection(BuildContext context, AppStateProvider state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "THEME CODE",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SelectableText(
                state.shareableThemeCode.toUpperCase(),
                style: TextStyle(
                  color: state.accentColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            onSubmitted: (value) => state.applyThemeCode(value),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: "Paste code here...",
              hintStyle: const TextStyle(color: Colors.white24),
              isDense: true,
              suffixIcon: Icon(
                Icons.download_rounded,
                color: state.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
