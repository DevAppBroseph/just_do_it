part of 'response_fav_bloc.dart';

class ResponseEvent {}

class OpenSlidingPanelFromFavEvent extends ResponseEvent {
  Task? selectTask;
  OpenSlidingPanelFromFavEvent({required this.selectTask});
}

class CloseSlidingPanelEvent extends ResponseEvent {}

class HideSlidingPanelEvent extends ResponseEvent {}

class OpenSlidingPanelToEvent extends ResponseEvent {
  double height;

  OpenSlidingPanelToEvent(this.height);
}
