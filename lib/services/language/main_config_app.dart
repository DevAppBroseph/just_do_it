class MainConfigApp {
  static int minLengthPassword = 4;

  static String fontSegoe = 'SegoeUI';

  static List<Language> languages = [
    Language(langCode: 'ru', langName: 'Russian', langCountryCode: 'RU'),
    Language(langCode: 'en', langName: 'English', langCountryCode: 'US'),
  ];
}

class Language {
  final String langCode;
  final String langCountryCode;
  final String langName;
  Language({required this.langCode, required this.langName, required this.langCountryCode});
}
