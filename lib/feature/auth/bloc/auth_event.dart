part of 'auth_bloc.dart';

class AuthEvent {}

class SendProfileEvent extends AuthEvent {
  UserRegModel userRegModel;

  SendProfileEvent(this.userRegModel);
}

class ConfirmCodeEvent extends AuthEvent {
  String phone;
  String code;

  ConfirmCodeEvent(this.phone, this.code);
}

class RestoreCodeEvent extends AuthEvent {
  String login;

  RestoreCodeEvent(this.login);
}

class RestoreCodeCheckEvent extends AuthEvent {
  String phone;
  String code;
  String updatePassword;

  RestoreCodeCheckEvent(this.phone, this.code, this.updatePassword);
}

class GetCategoriesEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  String phone;
  String password;

  SignInEvent(this.phone, this.password);
}

class CheckUserExistEvent extends AuthEvent {
  String phone;
  String email;

  CheckUserExistEvent(this.phone, this.email);
}
