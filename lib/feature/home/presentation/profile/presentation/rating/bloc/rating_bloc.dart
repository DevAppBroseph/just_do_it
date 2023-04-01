import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/network/repository.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc() : super(LoadingRatingState()) {
    on<GetRatingEvent>(_getRating);
    on<UpdateRatingEvent>(_updateRating);
  }
  late Reviews reviews;

  void _updateRating(
    UpdateRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    if (event.access != null) {
      Reviews? res = await Repository().getReviews(event.access);
      if (res != null) {
        if (res.ranking == null) {
          emit(NoRatingState());
        } else if (reviews.needsToGetUpdated(res)) {
          reviews = res;
          emit(UpdateRatingSuccessState());
        }
      } else {
        emit(UpdateRatingErrorState());
      }
    }
  }

  void _getRating(GetRatingEvent event, Emitter<RatingState> emit) async {
    emit(LoadingRatingState());
    if (event.access != null) {
      Reviews? res = await Repository().getReviews(event.access);
      if (res != null) {
        reviews = res;
        if (reviews.ranking == null) {
          emit(NoRatingState());
        } else {
          emit(UpdateRatingSuccessState());
        }
      } else {
        emit(UpdateRatingErrorState());
      }
    }
    emit(RatingInitState());
  }
}
