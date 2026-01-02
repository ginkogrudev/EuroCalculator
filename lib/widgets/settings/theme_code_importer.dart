// lib/widgets/settings/theme_code_importer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/haptic_service.dart';

class ThemeCodeImporter extends StatefulWidget {
  const ThemeCodeImporter({super.key});

  @override
  State<ThemeCodeImporter> createState() => _ThemeCodeImporterState();
}

class _ThemeCodeImporterState extends State<ThemeCodeImporter> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isDark = state.bgColor.computeLuminance() < 0.5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ВМЪКНИ КОД ЗА ТЕМА",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  onChanged: (val) => HapticService.light(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "FF2D55-000000",
                    hintStyle: TextStyle(color: Colors.white10),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.black26,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: () {
                  if (_codeController.text.contains('-')) {
                    state.applyThemeCode(_codeController.text.trim());
                    _codeController.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
                icon: const Icon(Icons.download_done_rounded),
                style: IconButton.styleFrom(backgroundColor: state.accentColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
