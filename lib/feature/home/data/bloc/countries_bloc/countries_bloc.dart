


import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/network/repository.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc() : super(CountriesLoading()) {
    on<GetCountryEvent>(_getCountries);
  }
  List<Countries>? countries;


  void _getCountries(GetCountryEvent event, Emitter<CountriesState> emit) async {
    emit(CountriesLoading());
    if (event.access != null) {
      countries = await Repository().countries(event.access);
      countries = await Repository().regions(event.access, countries!);

      emit(CountriesLoaded(country: countries));
     
    } else {
      emit(CountriesError());
    }
  }
}
