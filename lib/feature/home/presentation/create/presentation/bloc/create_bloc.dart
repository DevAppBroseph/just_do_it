import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc() : super(InitialState()) {
    on<OpenSlidingPanelEvent>(_openPanel);
    on<CloseSlidingPanelEvent>(_closePanel);
  }

  void _openPanel(
      OpenSlidingPanelEvent event, Emitter<CreateState> emit) async {
    emit(OpenSlidingPanelState());
  }

  void _closePanel(
      CloseSlidingPanelEvent event, Emitter<CreateState> emit) async {
    emit(CloseSlidingPanelState());
  }
}
