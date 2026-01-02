// lib/widgets/settings/share_app_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/app_state_provider.dart';
import '../../core/haptic_service.dart';

class ShareAppButton extends StatelessWidget {
  const ShareAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
        onTap: () {
          HapticService.heavy();

          // Use the .instance property to access the methods
          SharePlus.instance.share(
            ShareParams(
              text:
                  "Пресмятай лесно рестото в Евро и Лева с Euro Calculator! 🐷🇧🇬🇪🇺\nВземи го тук: https://ginkogrudev.github.io/GGSolutions/calculator.html",
              subject: "Euro Calculator - Твоят калкулатор за евро прехода",
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(Icons.stars_rounded, color: state.accentColor),
              const SizedBox(height: 8),
              const Text(
                "СПОЕДЕЛИ ПРИЛОЖЕНИЕТО С ПРИЯТЕЛ ИЛИ ВРАГ ",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.1,
                ),
              ),
              const Text(
                "Помогни на прасенцето да порасне",
                style: TextStyle(color: Colors.white24, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
