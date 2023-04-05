part of 'chat_bloc.dart';

class ChatEvent {}

class LoadChatEvent extends ChatEvent {
  int chatId;
  String? access;
  LoadChatEvent(this.access, this.chatId);
}

class UpdateChatEvent extends ChatEvent {
  int chatId;
  String? access;
  UpdateChatEvent(this.access, this.chatId);
}

class SendMessageEvent extends ChatEvent {
  String? access;
  String message;
  int to;
  SendMessageEvent(this.access, this.message, this.to);
}
