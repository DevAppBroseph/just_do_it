import 'package:flutter/services.dart';

class FormatterCurrency extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    String numberStr = '';
    int counter = 0;
    for (var i = text.length - 1; i >= 0; i--) {
      counter++;
      final str = text[i];
      if ((counter % 3) != 0 && i != 0) {
        numberStr = '$str$numberStr';
      } else if (i == 0) {
        numberStr = '$str$numberStr';
      } else {
        numberStr = ' $str$numberStr';
      }
    }
    numberStr.trim();
    return newValue.copyWith(text: numberStr, selection: TextSelection.collapsed(offset: numberStr.length));
  }
}
