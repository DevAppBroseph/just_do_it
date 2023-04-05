import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/network/repository.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(LoadingChatListState()) {
    on<LoadChatListEvent>(_loadChatList);
  }
  List<ChatList> chats = [];

  _loadChatList(LoadChatListEvent event, Emitter<ChatListState> emit) async {
    emit(LoadingChatListState());

    List<ChatList>? chats = await Repository().getChatList(event.access!);
    if (chats != null) {
      this.chats = chats;
      emit(LoadedChatListSuccessState());
    } else {
      emit(LoadedChatListErrorState());
    }
  }
}
