import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/core/utils/toasts.dart';
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
    on<GetCategoriesEvent>(_getCategories);
    on<SignInEvent>(_signIn);
  }

  void _getCategories(GetCategoriesEvent event, Emitter<AuthState> emit) async {
    List<Activities>? res = await Repository().getCategories();
    if (res != null) {
      emit(GetCategoriesState(res));
    }
  }

  void _sendProfile(SendProfileEvent event, Emitter<AuthState> emit) async {
    String? res = await Repository().confirmRegister(event.userRegModel);
    if (res == null) {
      emit(SendProfileSuccessState());
    } else {
      showAlertToast(res);
      emit(SendProfileErrorState(res));
    }
  }

  void _confirmCode(ConfirmCodeEvent event, Emitter<AuthState> emit) async {
    String? res =
        await Repository().confirmCodeRegistration(event.phone, event.code);
    if (res != null) {
      emit(ConfirmCodeRegistrSuccessState(res));
    } else {
      emit(ConfirmCodeRegistrErrorState());
    }
  }

  void _restoreProfile(RestoreCodeEvent event, Emitter<AuthState> emit) async {
    bool res = await Repository().resetPassword(event.login);
    if (res) {
      emit(ResetPasswordSuccessState());
    } else {
      emit(ResetPasswordErrorState());
    }
  }

  void _restoreCodeConfirm(
      RestoreCodeCheckEvent event, Emitter<AuthState> emit) async {
    String? res = await Repository()
        .confirmRestorePassword(event.code, event.phone, event.updatePassword);
    if (res != null) {
      emit(ConfirmRestoreSuccessState(res));
    } else {
      emit(ConfirmRestoreErrorState());
    }
  }

  void _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    String? res = await Repository().signIn(event.phone, event.password);
    if (res != null) {
      emit(SignInSuccessState(res));
    } else {
      emit(SignInErrorState());
    }
  }
}