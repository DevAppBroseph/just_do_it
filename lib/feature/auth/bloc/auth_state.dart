part of 'auth_bloc.dart';

class AuthState {}

class AuthInitState extends AuthState {}

class AppleSignInSuccessState extends AuthState {
  final String accessToken;

  AppleSignInSuccessState(this.accessToken);
}

class AppleSignInErrorState extends AuthState {
  final String errorMessage;

  AppleSignInErrorState(this.errorMessage);
}

class GoogleSignInSuccessState extends AuthState {
  final String accessToken;

  GoogleSignInSuccessState(this.accessToken);
}

class GoogleSignInErrorState extends AuthState {
  final String errorMessage;

  GoogleSignInErrorState(this.errorMessage);
}

class SendProfileSuccessState extends AuthState {
  SendProfileEvent sendProfileEvent;
  SendProfileSuccessState(this.sendProfileEvent);
}

class SendProfileErrorState extends AuthState {
  Map<String, dynamic>? error;
  SendProfileErrorState(this.error);
}

class ConfirmCodeRegisterInitialState extends AuthState {}

class ConfirmCodeRegistrSuccessState extends AuthState {
  String access;
  ConfirmCodeRegistrSuccessState(this.access);
}

class ConfirmCodeRegisterErrorState extends AuthState {
  String errorMessage;
  ConfirmCodeRegisterErrorState(this.errorMessage);
}

class ResetPasswordSuccessState extends AuthState {}

class ResetPasswordErrorState extends AuthState {}

class ConfirmRestoreSuccessState extends AuthState {
  String access;
  ConfirmRestoreSuccessState(this.access);
}

class ConfirmRestoreErrorState extends AuthState {}

class GetCategoriesState extends AuthState {
  List<TaskCategory> res;

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
