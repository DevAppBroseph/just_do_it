part of 'chat_bloc.dart';

class ChatState {}

class InitialState extends ChatState {}

class UpdateMenuState extends ChatState {}


class UpdateListMessageState extends ChatState {
  int? chatId;

  UpdateListMessageState(this.chatId);
}


class UpdateListMessageItemState extends ChatState {
  int? chatId;

  UpdateListMessageItemState({this.chatId});
}

class ReconnectState extends ChatState {}

class UpdateListPersonState extends ChatState {}
