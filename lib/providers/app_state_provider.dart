// lib/providers/app_state_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_theme.dart';
import '../core/haptic_service.dart';
import '../services/calculator_service.dart';

enum AccountType { personal, business }

class AppStateProvider extends ChangeNotifier {
  final CalculatorService _calculator = CalculatorService();
  late SharedPreferences _prefs;

  final TextEditingController billController = TextEditingController();
  final TextEditingController receivedController = TextEditingController();

  bool _isReady = false;
  bool _setupComplete = false;
  String _displayName = "";
  AccountType _accountType = AccountType.personal;

  Color _accentColor = AppTheme.piggyPink;
  Color _bgColor = AppTheme.darkBg;
  Color _textColor = Colors.white;

  bool _billInEuro = false;
  bool _isReceivedInEuro = false;

  // --- GETTERS ---
  bool get isReady => _isReady;
  bool get setupComplete => _setupComplete;
  String get displayName => _displayName;
  AccountType get accountType => _accountType;
  Color get accentColor => _accentColor;
  Color get bgColor => _bgColor;
  Color get textColor => _textColor;
  bool get billInEuro => _billInEuro;
  bool get isReceivedInEuro => _isReceivedInEuro;

  double get restoBgn => _calculator.calculateChangeBgn(
    billAmount: double.tryParse(billController.text) ?? 0.0,
    billInEuro: _billInEuro,
    receivedAmount: double.tryParse(receivedController.text) ?? 0.0,
    receivedInEuro: _isReceivedInEuro,
  );

  double get restoEuro => _calculator.convertToEur(restoBgn);

  AppStateProvider() {
    _initEngine();
  }

  Future<void> _initEngine() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _setupComplete = _prefs.getBool('setup_complete') ?? false;
      _displayName = _prefs.getString('display_name') ?? "";
      _accountType = AccountType.values[_prefs.getInt('account_type') ?? 0];

      _accentColor = Color(
        _prefs.getInt('accent_hex') ?? AppTheme.piggyPink.toARGB32(),
      );
      _bgColor = Color(_prefs.getInt('bg_hex') ?? AppTheme.darkBg.toARGB32());
      _textColor = Color(_prefs.getInt('text_hex') ?? Colors.white.toARGB32());

      billController.addListener(notifyListeners);
      receivedController.addListener(notifyListeners);
    } catch (e) {
      debugPrint("🚨 INIT ERROR: $e");
    } finally {
      _isReady = true;
      notifyListeners();
    }
  }

  // --- THEME & IDENTITY METHODS ---

  void _persistTheme() {
    _prefs.setInt('accent_hex', _accentColor.toARGB32());
    _prefs.setInt('bg_hex', _bgColor.toARGB32());
    _prefs.setInt('text_hex', _textColor.toARGB32());
  }

  void updateAccentColor(Color color) {
    _accentColor = color;
    _persistTheme();
    notifyListeners();
  }

  void updateBgColor(Color color) {
    _bgColor = color;
    _persistTheme();
    notifyListeners();
  }

  void updateTextColor(Color color) {
    _textColor = color;
    _persistTheme();
    notifyListeners();
  }

  void updateDisplayName(String name) {
    if (name.trim().isEmpty) return;
    _displayName = name.trim();
    _prefs.setString('display_name', _displayName);
    notifyListeners();
  }

  // --- FLOW CONTROL ---

  Future<void> completeSetup(String name, bool isBusiness) async {
    _displayName = name;
    _accountType = isBusiness ? AccountType.business : AccountType.personal;
    _setupComplete = true;

    // Apply default themes based on type
    if (isBusiness) {
      _accentColor = AppTheme.heroBlue;
      _bgColor = AppTheme.lightBg;
      _textColor = Colors.black;
    } else {
      _accentColor = AppTheme.piggyPink;
      _bgColor = AppTheme.darkBg;
      _textColor = Colors.white;
    }

    await _prefs.setString('display_name', name);
    await _prefs.setInt('account_type', _accountType.index);
    await _prefs.setBool('setup_complete', true);
    _persistTheme();

    notifyListeners();
    HapticService.success();
  }

  Future<void> hardReset() async {
    await _prefs.clear();
    _displayName = "";
    _setupComplete = false;
    _accountType = AccountType.personal;
    _accentColor = AppTheme.piggyPink;
    _bgColor = AppTheme.darkBg;
    _textColor = Colors.white;
    resetInputs(); // Clears controllers and notifies
  }

  // --- UI CONTROLS ---

  void toggleBillCurrency() {
    _billInEuro = !_billInEuro;
    notifyListeners();
  }

  void toggleReceivedCurrency() {
    _isReceivedInEuro = !_isReceivedInEuro;
    notifyListeners();
  }

  void resetInputs() {
    billController.clear();
    receivedController.clear();
    _billInEuro = false;
    _isReceivedInEuro = false;
    notifyListeners();
    HapticService.heavy();
  }

  @override
  void dispose() {
    billController.dispose();
    receivedController.dispose();
    super.dispose();
  }

  Future<void> resetTheme() async {
    // Reset to your signature branding
    _accentColor = AppTheme.piggyPink;
    _bgColor = AppTheme.darkBg;
    _textColor = Colors.white;

    _persistTheme(); // Save these to disk
    notifyListeners();
    HapticService.success();
  }
}
