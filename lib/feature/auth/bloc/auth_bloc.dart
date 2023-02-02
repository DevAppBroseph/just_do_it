import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitState()) {
    on<SendProfileEvent>(_sendProfile);
    on<ConfirmCodeEvent>(_confirmCode);
    on<RestoreCodeEvent>(_restoreProfile);
    on<RestoreCodeCheckEvent>(_restoreCodeConfirm);
  }

  void _sendProfile(SendProfileEvent event, Emitter<AuthState> emit) async {
    bool res = await Repository().confirmRegister(event.userRegModel);
    if (res) {
      emit(AuthSendProfileState());
    } else {
      emit(AuthSendProfileErrorState());
    }
  }

  void _confirmCode(ConfirmCodeEvent event, Emitter<AuthState> emit) async {
    bool res =
        await Repository().confirmCodeRegistration(event.phone, event.code);
    if (res) {
      emit(AuthSendCodeState());
    } else {
      emit(AuthSendCodeErrorState());
    }
  }

  void _restoreProfile(RestoreCodeEvent event, Emitter<AuthState> emit) async {
    bool res = await Repository().resetPassword(event.login);
    if (res) {
      emit(AuthSendCodeRestoreState());
    } else {
      emit(AuthSendCodeErrorState());
    }
  }

  void _restoreCodeConfirm(
      RestoreCodeCheckEvent event, Emitter<AuthState> emit) async {
    bool res = await Repository().confirmRestorePassword(event.code);
    if (res) {
      emit(AuthSendCodeState());
    } else {
      emit(AuthSendCodeErrorState());
    }
  }
}
