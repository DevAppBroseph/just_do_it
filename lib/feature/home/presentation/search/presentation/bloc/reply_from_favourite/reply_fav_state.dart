part of 'reply_fav_bloc.dart';

class ReplyState {}

class InitialState extends ReplyState {}

class OpenSlidingPanelState extends ReplyState {
  Task? selectTask;
  OpenSlidingPanelState({required this.selectTask});
}

class OpenSlidingPanelToState extends ReplyState {
  double height;

  OpenSlidingPanelToState(this.height);
}

class CloseSlidingPanelState extends ReplyState {}

class HideSlidingPanelState extends ReplyState {}
