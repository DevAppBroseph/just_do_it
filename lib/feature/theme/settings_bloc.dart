import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsInitial()) {
    on<ToggleThemeEvent>((event, emit) {
      if (state is SettingsInitial) {
        final currentState = state as SettingsInitial;
        emit(SettingsInitial(isDarkMode: !currentState.isDarkMode));
      }
    });
  }

  void toggleTheme() {
    add(ToggleThemeEvent());
  }
}

abstract class SettingsEvent {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ToggleThemeEvent extends SettingsEvent {}

abstract class SettingsState {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {
  final bool isDarkMode;

  const SettingsInitial({this.isDarkMode = false});

  @override
  List<Object> get props => [isDarkMode];
}
