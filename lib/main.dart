import 'package:EuroCalculator/core/app_theme.dart';
import 'package:EuroCalculator/providers/app_state_provider.dart';
import 'package:EuroCalculator/screens/home_view.dart';
import 'package:EuroCalculator/screens/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // 1. Essential for native plugin initialization (SharedPreferences)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Instantiate provider (Constructor triggers _initEngine automatically)
  final appState = AppStateProvider();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const EuroCalculatorApp(),
    ),
  );
}

class EuroCalculatorApp extends StatelessWidget {
  const EuroCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We watch the provider so the entire App rebuilds when theme colors change
    final state = context.watch<AppStateProvider>();

    // We build the MaterialApp ONCE.
    // This keeps the engine warm and prevents the "Double Loading" flicker.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Piggy Calculator',

      // Pass your dynamic colors into the global theme
      theme: AppTheme.buildTheme(
        accent: state.accentColor,
        background: state.bgColor,
        // textColor: state.textColor, // Enable this if your AppTheme supports it
      ),

      // THE GATEKEEPER LOGIC
      // If state isn't ready, show a blank scaffold that matches the native splash.
      // Once ready, it instantly swaps the 'home' widget without rebuilding the MaterialApp.
      home: !state.isReady
          ? const Scaffold(
              backgroundColor: Color(0xFF0D0D0D), // Piggy Dark Background
              body: SizedBox.expand(),
            )
          : (state.setupComplete ? const HomeView() : const SetupScreen()),
    );
  }
}
