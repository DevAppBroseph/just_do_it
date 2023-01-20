import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(InitialState()) {
    on<OpenSlidingPanelEvent>(_openPanel);
    on<CloseSlidingPanelEvent>(_closePanel);
  }

  void _openPanel(OpenSlidingPanelEvent event, Emitter<ChatState> emit) async {
    emit(OpenSlidingPanelState());
  }

  void _closePanel(
      CloseSlidingPanelEvent event, Emitter<ChatState> emit) async {
    emit(CloseSlidingPanelState());
  }
}
