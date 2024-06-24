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
            labelLarge: CustomTextStyle.sf11w400(DarkAppColors.blackPrimary),
            labelMedium: CustomTextStyle.sf12w400(DarkAppColors.blackPrimary),
            labelSmall: CustomTextStyle.sf13w400(DarkAppColors.blackPrimary),
            headlineLarge: CustomTextStyle.sf18w800(DarkAppColors.blackPrimary),
            headlineMedium:
                CustomTextStyle.sf17w600(DarkAppColors.blackPrimary),
            headlineSmall: CustomTextStyle.sf16w600(DarkAppColors.blackPrimary),
            displayLarge: CustomTextStyle.sf21w700(DarkAppColors.blackPrimary),
            displayMedium: CustomTextStyle.sf19w800(DarkAppColors.blackPrimary),
            displaySmall: CustomTextStyle.sf18w800(DarkAppColors.blackPrimary),
            titleLarge: CustomTextStyle.sf22w700(DarkAppColors.blackPrimary),
            titleMedium: CustomTextStyle.sf21w700(DarkAppColors.blackPrimary),
            titleSmall: CustomTextStyle.sf19w800(DarkAppColors.blackPrimary),
            bodyLarge: CustomTextStyle.sf18w800(DarkAppColors.blackPrimary),
            bodyMedium: CustomTextStyle.sf16w400(DarkAppColors.blackPrimary),
            bodySmall: CustomTextStyle.sf14w400(DarkAppColors.blackPrimary),
          )
        : TextTheme(
            labelLarge: CustomTextStyle.sf11w400(LightAppColors.blackPrimary),
            labelMedium: CustomTextStyle.sf12w400(LightAppColors.blackPrimary),
            labelSmall: CustomTextStyle.sf13w400(LightAppColors.blackPrimary),
            headlineLarge:
                CustomTextStyle.sf18w800(LightAppColors.blackPrimary),
            headlineMedium:
                CustomTextStyle.sf17w600(LightAppColors.blackPrimary),
            headlineSmall:
                CustomTextStyle.sf16w600(LightAppColors.blackPrimary),
            displayLarge: CustomTextStyle.sf21w700(LightAppColors.blackPrimary),
            displayMedium:
                CustomTextStyle.sf19w800(LightAppColors.blackPrimary),
            displaySmall: CustomTextStyle.sf18w800(LightAppColors.blackPrimary),
            titleLarge: CustomTextStyle.sf22w700(LightAppColors.blackPrimary),
            titleMedium: CustomTextStyle.sf21w700(LightAppColors.blackPrimary),
            titleSmall: CustomTextStyle.sf19w800(LightAppColors.blackPrimary),
            bodyLarge: CustomTextStyle.sf18w800(LightAppColors.blackPrimary),
            bodyMedium: CustomTextStyle.sf16w400(LightAppColors.greySecondary),
            bodySmall: CustomTextStyle.sf14w400(LightAppColors.greySecondary),
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
