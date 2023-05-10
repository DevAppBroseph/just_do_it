import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(InitialState()) {
    on<OpenSlidingPanelEvent>(_openPanel);
    on<CloseSlidingPanelEvent>(_closePanel);
    on<OpenSlidingPanelToEvent>(_openPanelTo);
    on<HideSlidingPanelEvent>(_hidePanel);
    on<ClearFilterEvent>(_clearFilter);
  }

  void _clearFilter(ClearFilterEvent event, Emitter<SearchState> emit) async {
    emit(ClearFilterState());
  }

  void _openPanel(
      OpenSlidingPanelEvent event, Emitter<SearchState> emit) async {
    emit(OpenSlidingPanelState());
  }

  void _openPanelTo(
      OpenSlidingPanelToEvent event, Emitter<SearchState> emit) async {
    emit(OpenSlidingPanelToState(event.height));
  }

  void _closePanel(
      CloseSlidingPanelEvent event, Emitter<SearchState> emit) async {
    emit(CloseSlidingPanelState());
  }

  void _hidePanel(
      HideSlidingPanelEvent event, Emitter<SearchState> emit) async {
    emit(HideSlidingPanelState());
  }
}
