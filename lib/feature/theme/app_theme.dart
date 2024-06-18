import 'package:flutter/material.dart';

@immutable
final class AppTheme {
  AppTheme({required this.mode, required this.seed})
      : darkTheme = ThemeData(
          colorSchemeSeed: seed,
          brightness: Brightness.dark,
          useMaterial3: true,
          textTheme: _buildTextTheme(Brightness.dark),
        ),
        lightTheme = ThemeData(
          colorSchemeSeed: seed,
          brightness: Brightness.light,
          useMaterial3: true,
          textTheme: _buildTextTheme(Brightness.light),
        );

  final ThemeMode mode;
  final Color seed;
  final ThemeData darkTheme;
  final ThemeData lightTheme;

  static final defaultTheme = AppTheme(
    mode: ThemeMode.system,
    seed: Colors.blue,
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    return brightness == Brightness.dark
        ? TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
          )
        : TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black87),
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
      other is AppTheme && seed == other.seed && mode == other.mode;

  @override
  int get hashCode => Object.hash(seed, mode);
}
