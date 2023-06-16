import 'package:flutter_bloc/flutter_bloc.dart';

part 'reply_fav_event.dart';
part 'reply_fav_state.dart';

class ReplyFromFavBloc extends Bloc<ReplyEvent, ReplyState> {
  ReplyFromFavBloc() : super(InitialState()) {
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