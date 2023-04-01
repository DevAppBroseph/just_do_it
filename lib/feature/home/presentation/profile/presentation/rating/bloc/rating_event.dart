part of 'rating_bloc.dart';

class RatingEvent {}

class GetRatingEvent extends RatingEvent {
  String? access;
  GetRatingEvent(this.access);
}

class UpdateRatingEvent extends RatingEvent {
  String? access;
  UpdateRatingEvent(this.access);
}
