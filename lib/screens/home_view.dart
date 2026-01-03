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
      // CRITICAL: Set to true so the Scaffold knows to move things
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                // Ensures the app takes up the full screen when keyboard is hidden
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildHeader(state, accent, isDark),

                      // Big Result Section
                      // Wrap this in a Flexible or fix the height so it doesn't
                      // disappear entirely, but stays visible
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            FittedBox(
                              // Ensures the big text scales down if squashed
                              child: Text(
                                "${state.changeInEuro.toStringAsFixed(2)} €",
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              "РЕСТО: ${state.changeInLev.toStringAsFixed(2)} лв",
                              style: TextStyle(
                                color: (isDark ? Colors.white : Colors.black)
                                    .withValues(alpha: .5),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Inputs Section
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
                            const SizedBox(height: 12),
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

                      // This spacer keeps the footer at the bottom when keyboard is off,
                      // but collapses when the keyboard is on.
                      const Spacer(),

                      // Action Footer
                      ActionFooter(state: state, isDark: isDark),

                      // Extra breathing room
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
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
                  color: accent.withValues(alpha: .5),
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
