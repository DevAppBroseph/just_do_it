import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/levels.dart';
import 'package:just_do_it/models/user_reg.dart';
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

  String evaluateGradeName(UserRegModel user, List<Levels> levels) {
    String gradeName = '';

    int balance = user.allbalance ?? 0;
    bool isRu = user.rus ?? false;

    for (var level in levels) {
      if (balance >= (level.mustCoins ?? 0)) {
        if (isRu) {
          gradeName = level.name ?? '';
        } else {
          gradeName = level.engName ?? '';
        }
      }
    }
    if (gradeName.isEmpty && levels.isNotEmpty) {
      if (isRu) {
        gradeName = levels.first.name ?? '';
      } else {
        gradeName = levels.first.engName ?? '';
      }
    }

    return gradeName;
  }
}
