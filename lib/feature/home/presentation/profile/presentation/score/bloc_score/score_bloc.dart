import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/levels.dart';
import 'package:just_do_it/network/repository.dart';

part 'score_event.dart';
part 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc() : super(ScoreLoading()) {
    on<GetScoreEvent>(_getScore);
  }
  List<Levels>? levels;

  void _getScore(GetScoreEvent event, Emitter<ScoreState> emit) async {
    emit(ScoreLoading());
    if (event.access != null) {
      levels = await Repository().levels(event.access);
      emit(ScoreLoaded(levels: levels));
    } else {
      emit(ScoreError());
    }
  }
}
