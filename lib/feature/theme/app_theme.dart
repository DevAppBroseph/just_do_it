import 'package:flutter/material.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';

@immutable
class AppTheme {
  AppTheme({
    required this.mode,
    required this.seed,
    required this.lightColors,
    required this.darkColors,
    required this.textStyles,
  })  : darkTheme = ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          primaryColor: DarkAppColors.yellowPrimary,
          textTheme: _buildTextTheme(textStyles.darkTextStyles),
          colorScheme:
              ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark)
                  .copyWith(secondary: DarkAppColors.yellowSecondary)
                  .copyWith(surface: DarkAppColors.yellowBackground),
        ),
        lightTheme = ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primaryColor: LightAppColors.yellowPrimary,
          textTheme: _buildTextTheme(textStyles.lightTextStyles),
          colorScheme: ColorScheme.fromSeed(
                  seedColor: seed, brightness: Brightness.light)
              .copyWith(secondary: LightAppColors.yellowSecondary)
              .copyWith(surface: LightAppColors.yellowBackground),
        );

  final ThemeMode mode;
  final Color seed;
  final LightAppColors lightColors;
  final DarkAppColors darkColors;
  final AppTextStyles textStyles;
  final ThemeData darkTheme;
  final ThemeData lightTheme;

  static TextTheme _buildTextTheme(dynamic textStyles) {
    return TextTheme();
  }

  TextStyle getStyle(TextStyle Function(LightTextStyles) lightStyle,
      TextStyle Function(DarkTextStyles) darkStyle) {
    return mode == ThemeMode.dark
        ? darkStyle(textStyles.darkTextStyles)
        : lightStyle(textStyles.lightTextStyles);
  }

  ThemeData computeTheme() {
    switch (mode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? darkTheme
            : lightTheme;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTheme &&
          seed == other.seed &&
          mode == other.mode &&
          lightColors == other.lightColors &&
          darkColors == other.darkColors;

  @override
  int get hashCode => Object.hash(seed, mode, lightColors, darkColors);
}
