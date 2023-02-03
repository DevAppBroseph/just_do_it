part of 'auth_bloc.dart';

class AuthState {}

class AuthInitState extends AuthState {}

class SendProfileSuccessState extends AuthState {}

class SendProfileErrorState extends AuthState {
  String? error;

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
