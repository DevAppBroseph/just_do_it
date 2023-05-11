import 'dart:convert';
import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/constants/server.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/models/new_message.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/dialog.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(InitialState()) {
    on<StartSocket>(_startSocket);
    on<GetListMessage>(_getListMessage);
    on<GetListMessageItem>(_getListMessageItem);
    on<SendMessageEvent>(_sendMessage);
    on<RefreshTripEvent>(_refresh);
    on<RefreshPersonChatEvent>(_refreshPersonChat);
  }

  WebSocketChannel? channel;
  List<ChatMessage> messages = [];
  List<ChatList> chatList = [];
  bool showPersonChat = true;
  int? idChat;

  void editShowPersonChat(bool value) => showPersonChat = value;

  void editChatId(int? value) {
    idChat = value;
  } 

  void _sendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    String newMessage = '{"message": "${event.message}", "to": "${event.id}"}';
    channel?.sink.add(newMessage.toString());

    List<ChatMessage> reversedList = List.from(messages.reversed);

    reversedList.add(
      ChatMessage(
        user: ChatUser(id: event.myId),
        createdAt: DateTime.now().toUtc(),
        text: event.message,
      ),
    );
    List<ChatMessage> reversedListTemp = List.from(reversedList.reversed);
    messages = reversedListTemp;
    add(RefreshTripEvent());
  }

  void _getListMessageItem(
      GetListMessageItem event, Emitter<ChatState> emit) async {
    final res = await Repository().getListMessageItem(event.access, '$idChat');
    messages.clear();
    for (var element in res) {
      messages.add(
        ChatMessage(
          user: ChatUser(id: element.user.id),
          createdAt: DateTime.now().toUtc(),
          text: element.text,
        ),
      );
    }
    List<ChatMessage> reversedList = List.from(messages.reversed);
    messages = reversedList;
    add(RefreshTripEvent());
  }

  void _getListMessage(GetListMessage event, Emitter<ChatState> emit) async {
    chatList.clear();
    final token = await Storage().getAccessToken();
    final res = await Repository().getListMessage(token ?? '');

    chatList.addAll(res);

    emit(UpdateListMessageState(idChat));
  }

  void _startSocket(StartSocket eventBloc, Emitter<ChatState> emit) async {
    final token = await Storage().getAccessToken();
    log('message _startSocket');
    channel = WebSocketChannel.connect(Uri.parse('ws://$webSocket/ws/$token'));
    channel?.stream.listen(
      (event) async {
        try {
          if (jsonDecode(event)['chat_id'] != null) {
            idChat = jsonDecode(event)['chat_id'];
          } else {
            var newMessage = NewMessageAnswer.fromJson(jsonDecode(event));
            if (showPersonChat) {
              MessageDialogs().showMessage(
                newMessage.fromName,
                newMessage.message,
                eventBloc.context,
                id: newMessage.id,
                name: newMessage.fromName,
                idWithChat: newMessage.from,
                image: newMessage.image,
              );
              editChatId(int.parse(newMessage.id!));
            }
            messages.add(
              ChatMessage(
                user: ChatUser(id: newMessage.from),
                createdAt: DateTime.now(),
                text: newMessage.message,
              ),
            );
          }
          add(RefreshPersonChatEvent());
          add(GetListMessage());
        } catch (e) {}
      },
      onDone: () {
        log('message onDone');
        _tryConnect();
      },
      // onError: (dynamic error) {
      //   log('message onError $error');
      //   _tryConnect();
      // },
      cancelOnError: false,
    );
  }

  void _tryConnect() async {
    log('message _tryConnect');
    await Future.delayed(const Duration(milliseconds: 1800));
    emit(ReconnectState());
  }

  void _refresh(RefreshTripEvent event, Emitter<ChatState> emit) =>
      emit(UpdateListMessageItemState());

  void _refreshPersonChat(
          RefreshPersonChatEvent event, Emitter<ChatState> emit) =>
      emit(UpdateListPersonState());
}
