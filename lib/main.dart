import 'package:EuroCalculator/core/app_theme.dart';
import 'package:EuroCalculator/providers/app_state_provider.dart';
import 'package:EuroCalculator/screens/home_view.dart';
import 'package:EuroCalculator/screens/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // 1. Mandatory for SharedPreferences and any native plugins
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Instantiate the Provider immediately
  final appState = AppStateProvider();

  // 3. Kick off the Disk Read (init)
  // We don't 'await' here because the UI handles the loading state via isReady
  appState.init();

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
    return Consumer<AppStateProvider>(
      builder: (context, state, child) {
        // 1. Check if the Provider has finished reading from Disk (Async check)
        if (!state.isReady) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Color(0xFF000000), // Match your dark background
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFFF2D55)),
              ),
            ),
          );
        }

        // 2. Once ready, build the real app
        return MaterialApp(
          theme: AppTheme.buildTheme(
            accent: state.accentColor,
            background: state.bgColor,
          ),
          debugShowCheckedModeBanner: false,
          title: 'Piggy Calculator',
          // THE GATEKEEPER
          // setupComplete = User has a name saved
          // !setupComplete = Show SetupScreen (even after a Hard Reset)
          home: state.setupComplete ? const HomeView() : const SetupScreen(),
        );
      },
    );
  }
}
