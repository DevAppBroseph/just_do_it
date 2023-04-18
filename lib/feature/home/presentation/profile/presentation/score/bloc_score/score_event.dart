part of 'score_bloc.dart';

class ScoreEvent {}

class GetScoreEvent extends ScoreEvent {
  String? access;
  GetScoreEvent(this.access);
}

