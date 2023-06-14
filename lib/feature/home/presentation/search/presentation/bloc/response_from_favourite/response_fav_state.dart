part of 'response_fav_bloc.dart';

class ResponseState {}

class InitialState extends ResponseState {}

class OpenSlidingPanelState extends ResponseState {
  Task? selectTask;
  OpenSlidingPanelState({required this.selectTask});
}

class OpenSlidingPanelToState extends ResponseState {
  double height;

  OpenSlidingPanelToState(this.height);
}

class CloseSlidingPanelState extends ResponseState {}

class HideSlidingPanelState extends ResponseState {}
