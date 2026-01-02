// lib/screens/setup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../core/haptic_service.dart';
import 'home_view.dart'; // Ensure you import your main calculator view

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _controller = TextEditingController();

  // Local state for the selector - simple and effective
  bool _isBusiness = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We use read here because we don't need to rebuild the whole screen
    // when theme changes during setup, but we use watch for the colors.
    final state = context.watch<AppStateProvider>();
    final accentColor = state.accentColor;
    final bgColor = state.bgColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "РЕГИСТРАЦИЯ",
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      fontSize: 10,
                    ),
                  ),
                  const Icon(
                    Icons.auto_awesome_outlined,
                    color: Colors.white10,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "ДОБРЕ ДОШЛИ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 60),

              // Name Input
              TextField(
                controller: _controller,
                cursorColor: accentColor,
                onChanged: (_) => HapticService.light(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: "ВАШЕТО ИМЕ",
                  labelStyle: const TextStyle(
                    color: Colors.white24,
                    fontSize: 12,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "ИЗБЕРЕТЕ ТИП ПРОФИЛ",
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Custom Type Selector
              Row(
                children: [
                  _buildTypeButton("ЛИЧЕН", !_isBusiness, accentColor),
                  const SizedBox(width: 12),
                  _buildTypeButton("БИЗНЕС", _isBusiness, accentColor),
                ],
              ),

              const Spacer(),

              // CTA Button
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: bgColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final name = _controller.text.trim();
                    if (name.isNotEmpty) {
                      HapticService.success();

                      // 1. Save state
                      state.updateDisplayName(name);
                      // If you have a setAccountType method:
                      // state.setAccountType(_isBusiness ? AccountType.business : AccountType.personal);

                      // 2. Mark setup as complete in Provider/Prefs
                      state.completeSetup(name, false);

                      // 3. Navigate to Home and clear stack
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeView()),
                        (route) => false,
                      );
                    } else {
                      HapticService.light(); // Provide feedback that input is required
                    }
                  },
                  child: const Text(
                    "ЗАПОЧНИ ДА СМЯТАШ",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, bool isSelected, Color accent) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticService.selection();
          setState(() => _isBusiness = (label == "БИЗНЕС"));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? accent : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? accent : Colors.transparent),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? (accent.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white)
                  : Colors.white38,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
