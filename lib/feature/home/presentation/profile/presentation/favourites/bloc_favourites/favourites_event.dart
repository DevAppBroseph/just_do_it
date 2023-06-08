part of 'favourites_bloc.dart';

class FavouritesEvent {}

class GetFavouritesEvent extends FavouritesEvent {
  String? access;
  GetFavouritesEvent(this.access);
}

