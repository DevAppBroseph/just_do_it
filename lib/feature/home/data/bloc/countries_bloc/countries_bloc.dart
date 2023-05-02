import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/network/repository.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc() : super(CountriesLoading()) {
    on<GetCountryEvent>(_getCountries);
    on<GetRegionEvent>(_getRegions);
    on<GetTownsEvent>(_getTowns);
  }

  List<Countries> country = [];
  List<Regions> region = [];
  List<Town> town = [];

  void _getCountries(
      GetCountryEvent event, Emitter<CountriesState> emit) async {
    emit(CountriesLoading());
    log('message 1');

    if (event.access != null) {
      log('message 2');
      country = await Repository().countries(event.access);
    } else {
      log('message 3');
      emit(CountriesError());
    }
  }

  void _getRegions(GetRegionEvent event, Emitter<CountriesState> emit) async {
    if (event.access != null) {
      region.clear();
      for (var element in event.countries) {
        region.addAll(await Repository().regions(event.access, element));
      }
      emit(CountriesUpdateState());
      add(GetTownsEvent(event.access, region));
    } else {
      emit(CountriesError());
    }
  }

  void _getTowns(GetTownsEvent event, Emitter<CountriesState> emit) async {
    if (event.access != null) {
      town.clear();
      for (var element in event.regions) {
        town.addAll(await Repository().towns(event.access, element));
      }
      emit(CountriesUpdateState());
    } else {
      emit(CountriesError());
    }
  }
}
