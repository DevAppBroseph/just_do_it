import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/network/repository.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  FavouritesBloc() : super(FavouritesLoading()) {
    on<GetFavouritesEvent>(_getFavourites);
  }
  Favourites? favourite;

  void _getFavourites(GetFavouritesEvent event, Emitter<FavouritesState> emit) async {
    // emit(FavouritesLoading());
    if (event.access != null) {
      favourite = await Repository().getLikeInfo(event.access);
      emit(FavouritesLoaded(favourite: favourite));
    } else {
      emit(FavouritesError());
    }
  }
}
