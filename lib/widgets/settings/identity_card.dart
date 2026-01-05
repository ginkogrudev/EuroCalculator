// lib/widgets/settings/identity_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';

class IdentityCard extends StatefulWidget {
  const IdentityCard({super.key});

  @override
  State<IdentityCard> createState() => _IdentityCardState();
}

class _IdentityCardState extends State<IdentityCard> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // Initialize with the current name from provider
    final initialName = context.read<AppStateProvider>().displayName;
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ИМЕ",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: state.textColor.withValues(
              alpha: 0.4,
            ), // FIXED: Reactive color
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8), // Reduced gap
        TextField(
          controller: _nameController,
          style: TextStyle(color: state.textColor), // FIXED: Reactive color
          decoration: InputDecoration(
            // TIGHTENING MARGINS:
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            filled: true,
            fillColor: state.textColor.withValues(alpha: 0.03),

            prefixIcon: Icon(
              Icons.person_outline,
              color: state.accentColor,
              size: 20,
            ),
            hintText: "Въведете име...",
            hintStyle: TextStyle(color: state.textColor.withValues(alpha: 0.3)),

            // Clean borders to avoid that "generic" Material look
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: state.accentColor.withValues(alpha: 0.5),
              ),
            ),
          ),
          onSubmitted: (val) {
            state.updateDisplayName(val);
          },
        ),
      ],
    );
  }
}
