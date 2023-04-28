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
    // on<SwitchCountry>(_switchCountry);
  }

  void _getCountries(GetCountryEvent event, Emitter<CountriesState> emit) async {
    emit(CountriesLoading());

    if (event.access != null) {
      final countries = await Repository().countries(event.access);
      log(countries.toString());
      final prefstate = state;
      if (prefstate is! CountriesLoaded) {
        emit(CountriesLoaded(
          country: countries,
          region: [],
          town: [],
        ));
      } else {
        emit(prefstate.copyWith(
          country: countries,
        ));
      }
    } else {
      emit(CountriesError());
    }
  }

  void _getRegions(GetRegionEvent event, Emitter<CountriesState> emit) async {
    if (event.access != null) {
      final regions = await Repository().regions(event.access, event.countries);
      log(regions.toString());
      final prefstate = state;
      if (prefstate is CountriesLoading) {
        emit(CountriesLoading());
      } else {
        if (prefstate is! CountriesLoaded) {
          emit(CountriesLoaded(
            country: [],
            region: regions,
            town: [],
          ));
        } else {
          emit(prefstate.copyWith(
            region: regions,
          ));
        }
      }
    } else {
      emit(CountriesError());
    }
  }

  void _getTowns(GetTownsEvent event, Emitter<CountriesState> emit) async {
    if (event.access != null) {
      final towns = await Repository().towns(event.access, event.regions);
      print(towns);
      final prefstate = state;
      if (prefstate is CountriesLoading) {
        emit(CountriesLoading());
      } else {
        if (prefstate is! CountriesLoaded) {
          emit(CountriesLoaded(
            country: [],
            region: [],
            town: towns,
          ));
        } else {
          emit(prefstate.copyWith(
            town: towns,
          ));
        }
      }
    } else {
      emit(CountriesError());
    }
  }

  // void _switchCountry(SwitchCountry event, Emitter<CountriesState> emit) async {
  //   final prefstate = state;
  //    if (prefstate is CountriesLoaded) {
  //       emit(prefstate.copyWith(
  //         switchCountry: !prefstate.switchCountry ,
  //       ));
  //    }
  // }
}
