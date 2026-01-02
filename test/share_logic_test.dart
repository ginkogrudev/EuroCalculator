// test/share_logic_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  test('Share Logic: Parameters are constructed correctly', () {
    final params = ShareParams(
      text: "https://ginkogrudev.github.io/GGSolutions/calculator.html",
      subject: "Euro Calculator",
    );

    // Verify the params hold the correct data before the native call
    expect(params.text, contains("ginkogrudev.github.io"));
    expect(params.subject, "Euro Calculator");
  });
}
