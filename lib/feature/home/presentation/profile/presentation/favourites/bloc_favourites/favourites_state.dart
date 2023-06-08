part of 'favourites_bloc.dart';

class FavouritesState {
  
}

class FavouritesEmpty extends FavouritesState {}

class FavouritesLoading extends FavouritesState {}

class FavouritesLoaded extends FavouritesState {
  final Favourites? favourite;
  

  FavouritesLoaded({required this.favourite});
}

class FavouritesError extends FavouritesState {}


