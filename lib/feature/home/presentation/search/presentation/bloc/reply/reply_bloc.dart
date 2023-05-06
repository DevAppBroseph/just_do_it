import 'package:flutter_bloc/flutter_bloc.dart';

part 'reply_event.dart';
part 'reply_state.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  ReplyBloc() : super(InitialState()) {
    on<OpenSlidingPanelEvent>(_openPanel);
    on<CloseSlidingPanelEvent>(_closePanel);
    on<OpenSlidingPanelToEvent>(_openPanelTo);
    on<HideSlidingPanelEvent>(_hidePanel);
  }

  void _openPanel(OpenSlidingPanelEvent event, Emitter<ReplyState> emit) async {
    emit(OpenSlidingPanelState());
  }

  void _openPanelTo(
      OpenSlidingPanelToEvent event, Emitter<ReplyState> emit) async {
    emit(OpenSlidingPanelToState(event.height));
  }

  void _closePanel(
      CloseSlidingPanelEvent event, Emitter<ReplyState> emit) async {
    emit(CloseSlidingPanelState());
  }

  void _hidePanel(HideSlidingPanelEvent event, Emitter<ReplyState> emit) async {
    emit(HideSlidingPanelState());
  }
}
