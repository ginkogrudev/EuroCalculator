import 'package:flutter/services.dart';

class HapticService {
  /// Light tap for button presses
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium tap for switching modes (Client to Business)
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Success vibration for resets or theme applied
  static Future<void> success() async {
    await HapticFeedback.vibrate();
  }

  /// Selection click for scrolling or picking colors
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Selection click for scrolling or picking colors
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  static void error() async {
    // A sequence of heavy impacts to signal a mistake
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.heavyImpact();
  }
}
