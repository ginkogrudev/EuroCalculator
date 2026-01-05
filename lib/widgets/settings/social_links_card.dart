// lib/widgets/settings/social_links_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/app_state_provider.dart';

class SocialLinksCard extends StatelessWidget {
  const SocialLinksCard({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ВРЪЗКИ",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: state.textColor.withValues(alpha: 0.38), // REACTIVE
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        _buildSocialTile(
          context,
          icon: Icons.language,
          title: "GG SOLUTIONS",
          subtitle: "Портфолио",
          url: "https://ginkogrudev.github.io/GGSolutions/index.html",
          state: state,
        ),
        const SizedBox(height: 8),
        _buildSocialTile(
          context,
          icon: Icons.code_rounded,
          title: "GITHUB",
          subtitle: "Отворен код",
          url: "https://github.com/ginkogrudev/",
          state: state,
        ),
      ],
    );
  }

  Widget _buildSocialTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
    required AppStateProvider state,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: state.textColor.withValues(alpha: 0.03), // REACTIVE BG
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () => _launch(url),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: state.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: state.accentColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: state.textColor, // REACTIVE TITLE
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: state.textColor.withValues(alpha: 0.4), // REACTIVE SUBTITLE
            fontSize: 11,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: state.textColor.withValues(alpha: 0.1), // REACTIVE ARROW
          size: 14,
        ),
      ),
    );
  }
}
