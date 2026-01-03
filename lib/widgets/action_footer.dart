import 'package:EuroCalculator/core/haptic_service.dart';
import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../screens/settings_screen.dart';

class ActionFooter extends StatelessWidget {
  final AppStateProvider state;
  final bool isDark;

  const ActionFooter({super.key, required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final accent = state.accentColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Settings Icon Button
              IconButton(
                onPressed: () {
                  HapticService.light();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark ? Colors.white30 : Colors.black26,
                ),
              ),
              const SizedBox(width: 12),
              // THE NEW CLEAR BUTTON
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    HapticService.success();
                    state.resetInputs();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent, // Piggy Pink
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "ИЗЧИСТИ",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Developed by GG Solutions",
            style: TextStyle(color: (accent), fontSize: 9, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
