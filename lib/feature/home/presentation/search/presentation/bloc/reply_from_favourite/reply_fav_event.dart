part of 'reply_fav_bloc.dart';

class ReplyEvent {}

class OpenSlidingPanelEvent extends ReplyEvent {}

class CloseSlidingPanelEvent extends ReplyEvent {}

class HideSlidingPanelEvent extends ReplyEvent {}

class OpenSlidingPanelToEvent extends ReplyEvent {
  double height;

  OpenSlidingPanelToEvent(this.height);
}
