import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

abstract class ThemeDataSource {
  Future<void> setTheme(AppTheme theme);
  Future<AppTheme?> getTheme();
}

final class ThemeDataSourceLocal implements ThemeDataSource {
  const ThemeDataSourceLocal(
      {required SharedPreferences sharedPreferences, required this.codec})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;
  final Codec<ThemeMode, String> codec;

  @override
  Future<void> setTheme(AppTheme theme) async {
    await _sharedPreferences.setInt('theme.seed_color', theme.seed.value);
    await _sharedPreferences.setString('theme.mode', codec.encode(theme.mode));
    // Сохранение дополнительных параметров тем, если нужно
  }

  @override
  Future<AppTheme?> getTheme() async {
    final seedColor = _sharedPreferences.getInt('theme.seed_color');
    final type = _sharedPreferences.getString('theme.mode');

    if (type == null || seedColor == null) return null;

    return AppTheme(
      seed: Color(seedColor),
      mode: codec.decode(type),
      lightColors: LightAppColors(),
      darkColors: DarkAppColors(),
    );
  }
}

final class ThemeModeCodec extends Codec<ThemeMode, String> {
  const ThemeModeCodec();

  @override
  Converter<String, ThemeMode> get decoder => const _ThemeModeDecoder();
  @override
  Converter<ThemeMode, String> get encoder => const _ThemeModeEncoder();
}

final class _ThemeModeDecoder extends Converter<String, ThemeMode> {
  const _ThemeModeDecoder();

  @override
  ThemeMode convert(String input) => switch (input) {
        'ThemeMode.dark' => ThemeMode.dark,
        'ThemeMode.light' => ThemeMode.light,
        'ThemeMode.system' => ThemeMode.system,
        _ => throw ArgumentError.value(
            input, 'input', 'Cannot convert $input to $ThemeMode'),
      };
}

final class _ThemeModeEncoder extends Converter<ThemeMode, String> {
  const _ThemeModeEncoder();

  @override
  String convert(ThemeMode input) => switch (input) {
        ThemeMode.dark => 'ThemeMode.dark',
        ThemeMode.light => 'ThemeMode.light',
        ThemeMode.system => 'ThemeMode.system',
      };
}
