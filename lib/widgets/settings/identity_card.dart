// lib/widgets/settings/identity_card.dart
import 'package:EuroCalculator/core/haptic_service.dart';
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
    final initialName = context.read<AppStateProvider>().displayName;
    _nameController = TextEditingController(text: initialName);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Име",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.white38,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "ВАШЕТО ИМЕ",
            prefixIcon: Icon(Icons.person_outline, color: state.accentColor),
          ),
          onSubmitted: (val) {
            state.updateDisplayName(val);
            HapticService.success(); // Confirms name change
          },
        ),
      ],
    );
  }
}
