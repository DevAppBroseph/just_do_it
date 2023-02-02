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
  String code;

  RestoreCodeCheckEvent(this.code);
}
