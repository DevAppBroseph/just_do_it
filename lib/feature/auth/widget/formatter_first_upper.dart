import 'package:flutter/services.dart';

class UpperTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String str = '';
    if (newValue.text.isNotEmpty) {
      str = newValue.text[0].toUpperCase();
      for (int i = 1; i < newValue.text.length; i++) {
        str += newValue.text[i];
      }
    }
    return TextEditingValue(text: str, selection: newValue.selection);
  }
}
