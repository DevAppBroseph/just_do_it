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
        ? TextTheme(
            // labelLarge: ,
            // labelMedium: ,
            // labelSmall: ,
            // headlineLarge: ,
            // headlineMedium: ,
            // headlineSmall: ,
            // displayLarge: ,
            // displayMedium: ,
            // displaySmall: ,
            // titleLarge: ,
            // titleMedium: ,titleSmall: ,
            // bodySmall: ,
            bodyLarge: TextStyle(color: DarkAppColors.whitePrimary),
            bodyMedium: TextStyle(color: DarkAppColors.greyPrimary),
          )
        : TextTheme(
            bodyLarge: TextStyle(color: LightAppColors.blackPrimary),
            bodyMedium: TextStyle(color: LightAppColors.greySecondary),
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
