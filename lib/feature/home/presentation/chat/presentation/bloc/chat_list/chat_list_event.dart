part of 'chat_list_bloc.dart';

class ChatListEvent {}

class LoadChatListEvent extends ChatListEvent {
  String? access;
  LoadChatListEvent(this.access);
}
