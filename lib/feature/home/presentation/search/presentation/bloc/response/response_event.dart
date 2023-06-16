part of 'response_bloc.dart';

class ResponseEvent {}

class OpenSlidingPanelEvent extends ResponseEvent {
  Task? selectTask;
  OpenSlidingPanelEvent({required this.selectTask});
}

class CloseSlidingPanelEvent extends ResponseEvent {}

class HideSlidingPanelEvent extends ResponseEvent {}

class OpenSlidingPanelToEvent extends ResponseEvent {
  double height;

  OpenSlidingPanelToEvent(this.height);
}
