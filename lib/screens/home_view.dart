// lib/screens/home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/amount_input_field.dart';
import '../widgets/action_footer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final accent = state.accentColor;
    final isDark = state.bgColor.computeLuminance() < 0.5;

    return Scaffold(
      backgroundColor: state.bgColor,
      resizeToAvoidBottomInset: false, // Prevents footer from jumping
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            _buildHeader(state, accent, isDark),

            // 2. Result Display (The Big Numbers)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${state.changeInEuro.toStringAsFixed(2)} €",
                      style: TextStyle(
                        color: accent,
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "РЕСТО: ${state.changeInLev.toStringAsFixed(2)} лв",
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black)
                            .withOpacity(0.4),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Inputs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  AmountInputField(
                    label: "СМЕТКА",
                    controller: state.billController,
                    accentColor: accent,
                    isDarkMode: isDark,
                  ),
                  const SizedBox(height: 16),
                  AmountInputField(
                    label: state.accountType == AccountType.business
                        ? "ПОЛУЧЕНО"
                        : "ВЗЕТО",
                    controller: state.receivedController,
                    accentColor: accent,
                    isDarkMode: isDark,
                  ),
                ],
              ),
            ),

            // 4. Action Footer
            ActionFooter(state: state, isDark: isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppStateProvider state, Color accent, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.accountType == AccountType.personal
                    ? "ЛИЧЕН ПРОФИЛ"
                    : "БИЗНЕС",
                style: TextStyle(
                  color: accent.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "Здравей, ${state.displayName}",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
