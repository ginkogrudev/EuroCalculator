// lib/screens/home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/amount_input_field.dart';
import 'settings_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
Widget build(BuildContext context) {
  // 1. Pull everything from the Provider
  final state = context.watch<AppStateProvider>();
  final accent = state.accentColor; // Use state, not hardcoded pink
  final bgColor = state.bgColor;     // Use state, not hardcoded black
  final textColor = state.textColor; // Use state for the secondary texts

  return Scaffold(
    backgroundColor: bgColor, // Dynamic background
    resizeToAvoidBottomInset: true, 
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // 1. TOP BAR
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Здравей, ${state.displayName}",
                    style: TextStyle(
                      color: textColor, // Dynamic text color
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const SettingsScreen())
                    ),
                    icon: Icon(Icons.settings_outlined, color: accent, size: 22),
                  ),
                ],
              ),
            ),

            // 2. THE HERO
            Column(
              children: [
                Text(
                  "РЕСТО",
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.2), // Dynamic opacity
                    fontSize: 10, 
                    fontWeight: FontWeight.w900
                  ),
                ),
                FittedBox(
                  child: Text(
                    "${state.restoEuro.toStringAsFixed(2)} €",
                    style: TextStyle(
                      color: accent, // Dynamic Pink
                      fontSize: 80, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Text(
                  "≈ ${state.restoBgn.toStringAsFixed(2)} лв",
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7), // Dynamic white/grey
                    fontSize: 22, 
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 3. THE INPUTS
            AmountInputField(
              label: "ОБЩА СМЕТКА",
              controller: state.billController,
              accentColor: accent, // Pass dynamic color
              isBillField: true,
            ),
            const SizedBox(height: 12),
            AmountInputField(
              label: state.accountType == AccountType.business 
                  ? "ПОЛУЧЕНИ ПАРИ" 
                  : "ДАДЕНИ ПАРИ",
              controller: state.receivedController,
              accentColor: accent, // Pass dynamic color
              isBillField: false,
            ),

            const SizedBox(height: 24),

            // 4. THE CLEAR BUTTON
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: state.resetInputs,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent, // Dynamic Pink button
                  foregroundColor: Colors.white, // Keep text white for contrast
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text("ИЗЧИСТИ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              "Developed by GG Solutions",
              style: TextStyle(color: textColor.withValues(alpha: 0.15), fontSize: 8),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
}