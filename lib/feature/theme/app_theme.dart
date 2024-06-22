import 'package:flutter/material.dart';
import 'package:just_do_it/constants/colors.dart';

@immutable
class AppTheme {
  AppTheme({
    required this.mode,
    required this.seed,
    required this.lightColors,
    required this.darkColors,
  })  : darkTheme = ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          primaryColor: DarkAppColors.yellowPrimary,
          textTheme: _buildTextTheme(Brightness.dark),
          colorScheme:
              ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark)
                  .copyWith(secondary: DarkAppColors.yellowSecondary)
                  .copyWith(surface: DarkAppColors.yellowBackground),
        ),
        lightTheme = ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primaryColor: LightAppColors.yellowPrimary,
          textTheme: _buildTextTheme(Brightness.light),
          colorScheme: ColorScheme.fromSeed(
                  seedColor: seed, brightness: Brightness.light)
              .copyWith(secondary: LightAppColors.yellowSecondary)
              .copyWith(surface: LightAppColors.yellowBackground),
        );

  final ThemeMode mode;
  final Color seed;
  final LightAppColors lightColors;
  final DarkAppColors darkColors;
  final ThemeData darkTheme;
  final ThemeData lightTheme;

  static final defaultTheme = AppTheme(
    mode: ThemeMode.system,
    seed: Colors.blue,
    lightColors: LightAppColors(),
    darkColors: DarkAppColors(),
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    return brightness == Brightness.dark
        ? const TextTheme(
            labelLarge: TextStyle(color: DarkAppColors.blackPrimary),
            labelMedium: TextStyle(color: DarkAppColors.greyPrimary),
            labelSmall: TextStyle(color: DarkAppColors.greyPrimary),
            headlineLarge: TextStyle(color: DarkAppColors.whitePrimary),
            headlineMedium: TextStyle(color: DarkAppColors.whitePrimary),
            headlineSmall: TextStyle(color: DarkAppColors.whitePrimary),
            displayLarge: TextStyle(color: DarkAppColors.whitePrimary),
            displayMedium: TextStyle(color: DarkAppColors.whitePrimary),
            displaySmall: TextStyle(color: DarkAppColors.whitePrimary),
            titleLarge: TextStyle(color: DarkAppColors.whitePrimary),
            titleMedium: TextStyle(color: DarkAppColors.whitePrimary),
            titleSmall: TextStyle(color: DarkAppColors.whitePrimary),
            bodyLarge: TextStyle(color: DarkAppColors.whitePrimary),
            bodyMedium: TextStyle(color: DarkAppColors.greyPrimary),
            bodySmall: TextStyle(color: DarkAppColors.greyPrimary),
          )
        : const TextTheme(
            labelLarge: TextStyle(color: LightAppColors.blackPrimary),
            labelMedium: TextStyle(color: LightAppColors.blackPrimary),
            labelSmall: TextStyle(color: LightAppColors.blackPrimary),
            headlineLarge: TextStyle(color: LightAppColors.blackPrimary),
            headlineMedium: TextStyle(color: LightAppColors.blackPrimary),
            headlineSmall: TextStyle(color: LightAppColors.blackPrimary),
            displayLarge: TextStyle(color: LightAppColors.blackPrimary),
            displayMedium: TextStyle(color: LightAppColors.blackPrimary),
            displaySmall: TextStyle(color: LightAppColors.blackPrimary),
            titleLarge: TextStyle(color: LightAppColors.blackPrimary),
            titleMedium: TextStyle(color: LightAppColors.blackPrimary),
            titleSmall: TextStyle(color: LightAppColors.blackPrimary),
            bodyLarge: TextStyle(color: LightAppColors.blackPrimary),
            bodyMedium: TextStyle(color: LightAppColors.greySecondary),
            bodySmall: TextStyle(color: LightAppColors.greySecondary),
          );
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
