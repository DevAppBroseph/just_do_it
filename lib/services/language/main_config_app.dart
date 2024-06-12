class MainConfigApp {
  static int minLengthPassword = 4;

  static String fontSegoe = 'SegoeUI';

  static List<Language> languages = [
    Language(langCode: 'en', langName: 'English', langCountryCode: 'US'),
    Language(langCode: 'ru', langName: 'Russian', langCountryCode: 'RU'),
  ];
}

class Language {
  final String langCode;
  final String langCountryCode;
  final String langName;
  Language({required this.langCode, required this.langName, required this.langCountryCode});
}
