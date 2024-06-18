import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';
import 'theme_repository.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

final class UpdateThemeSettingsEvent extends SettingsEvent {
  const UpdateThemeSettingsEvent({required this.appTheme});
  final AppTheme appTheme;
}

abstract class SettingsState {
  const SettingsState({this.locale, this.appTheme});
  final Locale? locale;
  final AppTheme? appTheme;
}

final class IdleSettingsState extends SettingsState {
  const IdleSettingsState({super.locale, super.appTheme});
}

final class ProcessingSettingsState extends SettingsState {
  const ProcessingSettingsState({super.locale, super.appTheme});
}

final class ErrorSettingsState extends SettingsState {
  const ErrorSettingsState({required this.cause, super.locale, super.appTheme});
  final Object cause;
}

final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(
      {required ThemeRepository themeRepository,
      required SettingsState initialState})
      : _themeRepo = themeRepository,
        super(initialState) {
    on<UpdateThemeSettingsEvent>((event, emit) => _updateTheme(event, emit));
  }

  final ThemeRepository _themeRepo;

  Future<void> _updateTheme(
      UpdateThemeSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(ProcessingSettingsState(
        locale: state.locale, appTheme: state.appTheme));
    try {
      await _themeRepo.setTheme(event.appTheme);
      emit(IdleSettingsState(locale: state.locale, appTheme: event.appTheme));
    } on Object catch (e) {
      emit(ErrorSettingsState(
          cause: e, locale: state.locale, appTheme: state.appTheme));
      rethrow;
    }
  }
}
