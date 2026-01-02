// lib/widgets/settings/theme_share_card.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/haptic_service.dart';

class ThemeShareCard extends StatelessWidget {
  const ThemeShareCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final code = state.shareableThemeCode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: state.accentColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            "ТВОЯТ ЦВЯТ: $code",
            style: TextStyle(
              color: state.accentColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              HapticService.success();
              Share.share(
                "Виж моята тема за Euro Piggy! Код: $code \nСвали приложението тук: https://your-landing-page.com",
                subject: "Euro Piggy Theme",
              );
            },
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: const Text("СПОДЕЛИ ТЕМАТА"),
            style: ElevatedButton.styleFrom(
              backgroundColor: state.accentColor,
              foregroundColor: state.bgColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
