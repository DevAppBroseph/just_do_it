import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/constants/colors.dart';

import 'app_theme.dart';
import 'settings_bloc.dart';

abstract class ThemeScopeController {
  AppTheme get theme;
  void toggleThemeMode();
}

class SettingsScope extends StatefulWidget {
  const SettingsScope({
    required this.child,
    required this.settingsBloc,
    super.key,
  });

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
  void toggleThemeMode() {
    widget.settingsBloc.toggleTheme();
  }

  @override
  AppTheme get theme {
    final isDarkMode = widget.settingsBloc.state is SettingsInitial &&
        (widget.settingsBloc.state as SettingsInitial).isDarkMode;
    return AppTheme(
      mode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      seed: Colors.blue,
      lightColors: LightAppColors(),
      darkColors: DarkAppColors(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (_) => widget.settingsBloc,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final currentTheme = theme;
          return MaterialApp(
            theme: currentTheme.lightTheme,
            darkTheme: currentTheme.darkTheme,
            themeMode: currentTheme.mode,
            home: _InheritedSettingsScope(
              controller: this,
              state: state,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

class _InheritedSettingsScope extends InheritedWidget {
  const _InheritedSettingsScope({
    required this.controller,
    required this.state,
    required super.child,
  });

  final ThemeScopeController controller;
  final SettingsState state;

  @override
  bool updateShouldNotify(_InheritedSettingsScope oldWidget) =>
      state != oldWidget.state;
}
