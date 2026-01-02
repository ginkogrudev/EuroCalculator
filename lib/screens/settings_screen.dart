// lib/screens/settings_screen.dart
import 'package:EuroCalculator/screens/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/settings/identity_card.dart';
import '../widgets/settings/social_links_card.dart';
import '../widgets/settings/theme_code_importer.dart';
import '../widgets/settings/color_picker_sheet.dart';
import '../widgets/settings/theme_share_card.dart'; // New
import '../widgets/settings/share_app_button.dart'; // New

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: state.bgColor, // Reactive background
      appBar: AppBar(
        title: const Text(
          "ПРОФИЛ И ДИЗАЙН",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Ensure back button matches theme
        iconTheme: IconThemeData(color: state.accentColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const IdentityCard(),
          const SizedBox(height: 40),

          _buildHeader("ПЕРСОНАЛИЗАЦИЯ"),
          const SizedBox(height: 16),

          // THE DUAL COLOR PICKER TRIGGER
          ListTile(
            onTap: () => showPiggyColorPicker(context, state),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: Icon(Icons.palette_rounded, color: state.accentColor),
            title: const Text(
              "ИЗБЕРИ ЦВЕТОВЕ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: Colors.white.withOpacity(0.03),
          ),

          const SizedBox(height: 12),
          const ThemeCodeImporter(),
          const SizedBox(height: 12),
          const ThemeShareCard(), // Users can now export their look

          const SizedBox(height: 40),
          _buildHeader("ВРЪЗКА С НАС"),
          const SocialLinksCard(),

          const ShareAppButton(), // The "Piggy Movement" button

          const SizedBox(height: 40),

          // lib/screens/settings_screen.dart
          TextButton.icon(
            key: const Key('hard_reset_button'), 
            onPressed: () => _confirmReset(context, state),
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
            label: const Text(
              "ИЗЧИСТИ ВСИЧКИ ДАННИ",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Colors.white38,
        letterSpacing: 2,
      ),
    );
  }

  void _confirmReset(BuildContext context, AppStateProvider state) {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "НУЛИРАНЕ?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        content: const Text(
          "Това ще изтрие името и персонализираните ви цветове.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(innerContext),
            child: const Text("ОТКАЗ", style: TextStyle(color: Colors.white24)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await state.hardReset();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SetupScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              "ИЗТРИЙ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
