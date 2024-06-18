import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/constants/colors.dart';

import 'app_theme.dart';
import 'settings_bloc.dart';

abstract interface class ThemeScopeController {
  AppTheme get theme;
  void setThemeMode(ThemeMode themeMode);
  void setThemeSeedColor(Color color);
}

class SettingsScope extends StatefulWidget {
  const SettingsScope(
      {required this.child, required this.settingsBloc, super.key});

  final Widget child;
  final SettingsBloc settingsBloc;

  static ThemeScopeController themeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedSettingsScope>()!
        .controller;
  }

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

class _SettingsScopeState extends State<SettingsScope>
    implements ThemeScopeController {
  @override
  void setThemeMode(ThemeMode themeMode) {
    widget.settingsBloc.add(UpdateThemeSettingsEvent(
        appTheme: AppTheme(
            mode: themeMode,
            seed: theme.seed,
            lightColors: LightAppColors(),
            darkColors: DarkAppColors())));
  }

  @override
  void setThemeSeedColor(Color color) {
    widget.settingsBloc.add(UpdateThemeSettingsEvent(
        appTheme: AppTheme(
            mode: theme.mode,
            seed: color,
            lightColors: LightAppColors(),
            darkColors: DarkAppColors())));
  }

  @override
  AppTheme get theme =>
      widget.settingsBloc.state.appTheme ?? AppTheme.defaultTheme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: widget.settingsBloc,
      builder: (context, state) {
        return MaterialApp(
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: theme.mode,
          home: _InheritedSettingsScope(
            controller: this,
            state: state,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _InheritedSettingsScope extends InheritedWidget {
  const _InheritedSettingsScope(
      {required this.controller, required this.state, required super.child});

  final ThemeScopeController controller;
  final SettingsState state;

  @override
  bool updateShouldNotify(_InheritedSettingsScope oldWidget) =>
      state != oldWidget.state;
}
