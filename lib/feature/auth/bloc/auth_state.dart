part of 'auth_bloc.dart';

class AuthState {}

class AuthInitState extends AuthState {}

class SendProfileSuccessState extends AuthState {}

class SendProfileErrorState extends AuthState {
  Map<String, dynamic>? error;

  SendProfileErrorState(this.error);
}

class ConfirmCodeRegistrSuccessState extends AuthState {
  String access;
  ConfirmCodeRegistrSuccessState(this.access);
}

class ConfirmCodeRegistrErrorState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {}

class ResetPasswordErrorState extends AuthState {}

class ConfirmRestoreSuccessState extends AuthState {
  String access;
  ConfirmRestoreSuccessState(this.access);
}

class ConfirmRestoreErrorState extends AuthState {}

class GetCategoriesState extends AuthState {
  List<Activities> res;

  GetCategoriesState(this.res);
}

class SignInSuccessState extends AuthState {
  String access;
  SignInSuccessState(this.access);
}

class SignInErrorState extends AuthState {}

class CheckUserState extends AuthState {
  String? error;
  CheckUserState(this.error);
}

class ConfirmCodeResetSuccessState extends AuthState {
  String access;
  ConfirmCodeResetSuccessState(this.access);
}

class ConfirmCodeResetErrorState extends AuthState {}

class EditPasswordSuccessState extends AuthState {}

class EditPasswordErrorState extends AuthState {}
