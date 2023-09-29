import 'package:easy_localization/easy_localization.dart';

class DataFormatter {
  static String formatHourAndMinute(DateTime dateTime) {
    return DateFormat.Hm()
        .format(dateTime); // 'H' for 24-hour format, 'h' for 12-hour format
  }

  static String addSpacesToNumber(int? data) {
    if (data!=null&&data >= 1000) {
      var formatter = NumberFormat('#,###');

      return formatter.format(data).replaceAll(',', ' ');
    } else {
      return data.toString();
    }
  }

  static String convertCurrencyNameIntoSymbol(String? currencyName) {
    switch (currencyName) {
      case "Дирхам":
        return "AED";
      case "Биткоин":
        return "BTC";
      case "Российский рубль":
        return "₽";
      case "Доллар США":
        return "\$";
      case "Евро":
        return "€";
      default:
        return "";
    }
  }
}
