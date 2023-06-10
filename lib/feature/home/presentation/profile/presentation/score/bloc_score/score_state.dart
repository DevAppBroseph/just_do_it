part of 'score_bloc.dart';

class ScoreState {
  
}

class ScoreEmpty extends ScoreState {}

class ScoreLoading extends ScoreState {}

class ScoreLoaded extends ScoreState {
  final List<Levels>? levels;
  

  ScoreLoaded({required this.levels});
}

class ScoreError extends ScoreState {}


