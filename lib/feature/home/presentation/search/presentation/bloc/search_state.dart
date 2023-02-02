part of 'search_bloc.dart';

class SearchState {}

class InitialState extends SearchState {}

class OpenSlidingPanelState extends SearchState {}

class OpenSlidingPanelToState extends SearchState {
  double height;

  OpenSlidingPanelToState(this.height);
}

class CloseSlidingPanelState extends SearchState {}

class HideSlidingPanelState extends SearchState {}
