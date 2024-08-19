import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Überprüfen, ob das Format den Anforderungen entspricht
    final regExp = RegExp(r'^-?\d{0,10}(\.\d{0,2})?$');
    if (!regExp.hasMatch(text)) {
      return oldValue; // wenn es nicht übereinstimmt, behalte den alten Wert bei
    }

    return newValue; // falls übereinstimmt, wird der neue Wert akzeptiert
  }
}
