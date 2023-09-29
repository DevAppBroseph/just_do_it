import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/task/task.dart';

part 'response_fav_event.dart';
part 'response_fav_state.dart';

class ResponseBlocFromFav extends Bloc<ResponseEvent, ResponseState> {
  ResponseBlocFromFav() : super(InitialState()) {
    on<OpenSlidingPanelFromFavEvent>(_openPanel);
    on<CloseSlidingPanelEvent>(_closePanel);
    on<OpenSlidingPanelToEvent>(_openPanelTo);
    on<HideSlidingPanelEvent>(_hidePanel);
  }

  void _openPanel(OpenSlidingPanelFromFavEvent event, Emitter<ResponseState> emit) async {
    emit(OpenSlidingPanelState(selectTask: event.selectTask));
  }

  void _openPanelTo(OpenSlidingPanelToEvent event, Emitter<ResponseState> emit) async {
    emit(OpenSlidingPanelToState(event.height));
  }

  void _closePanel(CloseSlidingPanelEvent event, Emitter<ResponseState> emit) async {
    emit(CloseSlidingPanelState());
  }

  void _hidePanel(HideSlidingPanelEvent event, Emitter<ResponseState> emit) async {
    emit(HideSlidingPanelState());
  }
}
