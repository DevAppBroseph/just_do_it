


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



  void _getCountries(GetCountryEvent event, Emitter<CountriesState> emit) async {
    emit(CountriesLoading());
    if (event.access != null) {
      final countries = await Repository().countries(event.access);
      final regions = await Repository().regions(event.access, countries);
      final towns = await Repository().towns(event.access, regions);

      emit(CountriesLoaded(country: countries, region: regions, town: towns));
     
    } else {
      emit(CountriesError());
    }
  }
}
