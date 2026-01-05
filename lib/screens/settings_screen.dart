// lib/screens/settings_screen.dart
import 'package:EuroCalculator/screens/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/settings/identity_card.dart';
import '../widgets/settings/social_links_card.dart';
import '../widgets/settings/color_picker_sheet.dart';
import '../widgets/settings/share_app_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: state.bgColor,
      appBar: AppBar(
        title: Text(
          "ПРОФИЛ И ДИЗАЙН",
          style: TextStyle(
            color: state.textColor, // FIXED: Reactive title
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: state.accentColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const IdentityCard(),
          const SizedBox(height: 40),

          _buildHeader("ПЕРСОНАЛИЗАЦИЯ", state.textColor),
          const SizedBox(height: 16),

          ListTile(
            onTap: () => showPiggyColorPicker(context, state),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: Icon(Icons.palette_rounded, color: state.accentColor),
            title: Text(
              "ИЗБЕРИ ЦВЕТОВЕ",
              style: TextStyle(
                color: state.textColor, // FIXED: Reactive text
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: state.textColor.withValues(alpha: 0.2),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: state.textColor.withValues(alpha: 0.03),
          ),

          const SizedBox(height: 40),
          _buildHeader("ВРЪЗКА С НАС", state.textColor),
          const SocialLinksCard(),
          const ShareAppButton(),

          const SizedBox(height: 40),

          // EMERGENCY RESET BUTTON
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

  Widget _buildHeader(String text, Color textColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: textColor.withValues(alpha: 0.4), // FIXED: Reactive header
        letterSpacing: 2,
      ),
    );
  }

  void _confirmReset(BuildContext context, AppStateProvider state) {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        backgroundColor: state.bgColor.withValues(
          alpha: 0.95,
        ), // FIXED: Dialog matches theme
        surfaceTintColor: state.accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "НУЛИРАНЕ?",
          style: TextStyle(
            color: state.textColor, // FIXED
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        content: Text(
          "Това ще изтрие името и персонализираните ви цветове.",
          style: TextStyle(
            color: state.textColor.withValues(alpha: 0.7),
          ), // FIXED
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(innerContext),
            child: Text(
              "ОТКАЗ",
              style: TextStyle(color: state.textColor.withValues(alpha: 0.3)),
            ),
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
