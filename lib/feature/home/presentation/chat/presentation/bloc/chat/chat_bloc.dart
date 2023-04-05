import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/network/repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(LoadingChatState()) {
    on<SendMessageEvent>(_sendMessage);
    on<LoadChatEvent>(_loadChat);
    on<UpdateChatEvent>(_updateChat);
    // on<CloseSlidingPanelEvent>(_closePanel);
  }
  Chat? chat;

  _loadChat(LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(LoadingChatState());
    Chat? chat = await Repository().getChat(event.access!, event.chatId);

    if (chat != null) {
      this.chat = chat;
      emit(LoadedChatSuccessState());
    } else {
      emit(LoadedChatErrorState());
    }
  }

  _updateChat(UpdateChatEvent event, Emitter<ChatState> emit) async {
    Chat? chat = await Repository().getChat(event.access!, event.chatId);

    if (chat != null) {
      this.chat = chat;
      emit(UpdatedChatSuccessState());
    } else {
      emit(UpdatedChatErrorState());
    }
  }

  _sendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(SendingMessageState());

    await Repository().sendMessage(event.access!, event.message, event.to);
    emit(SentMessageSuccessState());
  }
}
