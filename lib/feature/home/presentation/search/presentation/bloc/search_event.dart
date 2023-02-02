part of 'search_bloc.dart';

class SearchEvent {}

class OpenSlidingPanelEvent extends SearchEvent {}

class CloseSlidingPanelEvent extends SearchEvent {}

class HideSlidingPanelEvent extends SearchEvent {}

class OpenSlidingPanelToEvent extends SearchEvent {
  double height;

  OpenSlidingPanelToEvent(this.height);
}
