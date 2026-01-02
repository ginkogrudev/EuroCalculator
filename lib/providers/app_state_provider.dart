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

  // --- PERSISTENT STATE ---
  bool _isReady = false;
  bool _setupComplete = false;
  String _displayName = "";
  AccountType _accountType = AccountType.personal;

  // Theme State
  Color _accentColor = AppTheme.piggyPink;
  Color _bgColor = AppTheme.darkBg;

  // Calculation State
  bool _billInEuro = false;
  bool _isReceivedInEuro = false;

  // --- GETTERS ---
  bool get isReady => _isReady;
  bool get setupComplete => _setupComplete;
  String get displayName => _displayName;
  AccountType get accountType => _accountType;
  Color get accentColor => _accentColor;
  Color get bgColor => _bgColor;
  bool get billInEuro => _billInEuro;
  bool get isReceivedInEuro => _isReceivedInEuro;

  AppStateProvider() {
    _initEngine();
  }

  Future<void> _initEngine() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      // Load User Data
      _setupComplete = _prefs.getBool('setup_complete') ?? false;
      _displayName = _prefs.getString('display_name') ?? "";
      _accountType = AccountType.values[_prefs.getInt('account_type') ?? 0];

      // Load Theme (Consistent keys: accent_hex & bg_hex)
      int accentValue =
          _prefs.getInt('accent_hex') ?? AppTheme.piggyPink.toARGB32();
      int bgValue = _prefs.getInt('bg_hex') ?? AppTheme.darkBg.toARGB32();

      _accentColor = Color(accentValue);
      _bgColor = Color(bgValue);

      // Math listeners
      billController.addListener(notifyListeners);
      receivedController.addListener(notifyListeners);
    } catch (e) {
      debugPrint("🚨 INIT ERROR: $e");
    } finally {
      _isReady = true;
      notifyListeners();
    }
  }

  // --- IDENTITY METHODS (FIXED) ---

  Future<void> updateDisplayName(String name) async {
    if (name.trim().isEmpty) return;
    _displayName = name;
    await _prefs.setString('display_name', name);
    notifyListeners();
    HapticService.success();
  }

  Future<void> completeSetup(String name, bool isBusiness) async {
    _displayName = name;
    _accountType = isBusiness ? AccountType.business : AccountType.personal;
    _setupComplete = true;

    // Default branding logic
    if (isBusiness) {
      _accentColor = AppTheme.heroBlue;
      _bgColor = AppTheme.lightBg;
    } else {
      _accentColor = AppTheme.piggyPink;
      _bgColor = AppTheme.darkBg;
    }

    await _prefs.setString('display_name', name);
    await _prefs.setInt('account_type', _accountType.index);
    await _prefs.setBool('setup_complete', true);
    await _persistTheme();

    notifyListeners();
    HapticService.success();
  }

  // Legacy support for your older UI call
  Future<void> finishSetup(String name, AccountType type) async {
    await completeSetup(name, type == AccountType.business);
  }

  // --- THEME METHODS (FIXED) ---

  void updateAccentColor(Color color) {
    _accentColor = color;
    _persistTheme();
    notifyListeners();
    HapticService.selection();
  }

  void updateBgColor(Color color) {
    _bgColor = color;
    _persistTheme();
    notifyListeners();
    HapticService.selection();
  }

  // 1. Fixes the 'init' error in main.dart
  // We point 'init' to our internal engine startup
  Future<void> init() async {
    await _initEngine();
  }

  // 2. Fixes the 'refresh' error in AmountField
  // This forces the UI to re-draw when text changes
  void refresh() {
    notifyListeners();
  }

  // 3. Fixes the 'resetInputs' error in ActionFooter
  // Clears the calculators and gives the user feedback
  void resetInputs() {
    billController.clear();
    receivedController.clear();
    _billInEuro = false;
    _isReceivedInEuro = false;
    HapticService.heavy(); // Physical feedback for "Wipe"
    notifyListeners();
  }

  String get shareableThemeCode =>
      "${_accentColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}-"
      "${_bgColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}";

  void applyThemeCode(String code) {
    try {
      final cleanCode = code.trim().toUpperCase();
      final parts = cleanCode.split('-');
      final hexRegex = RegExp(r'^[0-9A-F]{6}$');

      if (parts.length == 2 &&
          hexRegex.hasMatch(parts[0]) &&
          hexRegex.hasMatch(parts[1])) {
        _accentColor = Color(int.parse("FF${parts[0]}", radix: 16));
        _bgColor = Color(int.parse("FF${parts[1]}", radix: 16));
        _persistTheme();
        HapticService.success();
        notifyListeners();
      } else {
        HapticService.error();
      }
    } catch (e) {
      HapticService.error();
    }
  }

  Future<void> _persistTheme() async {
    await _prefs.setInt('accent_hex', _accentColor.toARGB32());
    await _prefs.setInt('bg_hex', _bgColor.toARGB32());
  }

  // --- CALCULATION LOGIC ---

  double get changeInLev {
    double bill = double.tryParse(billController.text) ?? 0.0;
    double received = double.tryParse(receivedController.text) ?? 0.0;
    return _calculator.calculateChangeBgn(
      billAmount: bill,
      billInEuro: _billInEuro,
      receivedAmount: received,
      receivedInEuro: _isReceivedInEuro,
    );
  }

  double get changeInEuro => _calculator.convertToEur(changeInLev);

  void toggleBillCurrency() {
    _billInEuro = !_billInEuro;
    HapticService.selection();
    notifyListeners();
  }

  void toggleReceivedCurrency() {
    _isReceivedInEuro = !_isReceivedInEuro;
    HapticService.selection();
    notifyListeners();
  }

  Future<void> hardReset() async {
    await _prefs.clear();
    _displayName = "";
    _setupComplete = false;
    _accentColor = AppTheme.piggyPink;
    _bgColor = AppTheme.darkBg;
    billController.clear();
    receivedController.clear();
    notifyListeners();
  }
}
