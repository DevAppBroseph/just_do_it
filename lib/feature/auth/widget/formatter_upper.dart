import 'package:flutter/services.dart';

class UpperEveryTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String str = '';
    if (newValue.text.isNotEmpty) {
      str = newValue.text[0].toUpperCase();
      for (int i = 1; i < newValue.text.length; i++) {
        if (i >= 2) {
          if (newValue.text[i - 2] == '.' ||
              newValue.text[i - 2] == '?' ||
              newValue.text[i - 2] == '!') {
            str += newValue.text[i].toUpperCase();
          } else {
            str += newValue.text[i];
          }
        } else {
          str += newValue.text[i];
        }
      }
    }
    return TextEditingValue(text: str, selection: newValue.selection);
  }
}
