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
    on<GetAllRegionEvent>(_getAllRegions);
    on<GetTownsEvent>(_getTowns);
    on<GetAllTownsEvent>(_getAllTowns);
    on<ChangeCountryEvent>(_changeCountry);
    on<ChangeRegionEvent>(_changeRegion);
    on<ChangeTownEvent>(_changeTowns);
    on<RemoveCountryEvent>(_removeCountry);
    on<RemoveRegionEvent>(_removeRegion);
    on<RemoveTownEvent>(_removeTown);
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

  void _changeCountry(ChangeCountryEvent event, Emitter<CountriesState> emit) async {
    final prefState = state;
    if (prefState is! CountriesLoaded) {
      return;
    }
    final selectCountry = prefState.selectCountry.toList();
    final isSelect = selectCountry.any((element) => element.id == event.countries.id);
    print(isSelect);
    if (isSelect) {
      selectCountry.removeWhere((element) => element.id == event.countries.id);
    } else {
      selectCountry.add(event.countries);
    }
    emit(prefState.copyWith(selectCountry: selectCountry));
  }

  void _removeCountry(RemoveCountryEvent event, Emitter<CountriesState> emit) async {
    final prefState = state;
    if (prefState is! CountriesLoaded) {
      return;
    }
    final selectCountry = prefState.selectCountry.toList();
    final isSelectCountry = selectCountry.any((element) => element.id == event.countries.id);
    if (isSelectCountry) {
      selectCountry.removeWhere((element) => element.id == event.countries.id);
    }
    emit(prefState.copyWith(selectCountry: selectCountry));
  }

  void _removeRegion(RemoveRegionEvent event, Emitter<CountriesState> emit) async {
    final prefState = state;
    if (prefState is! CountriesLoaded) {
      return;
    }

    final selectRegion = prefState.selectRegion.toList();
    final isSelectRegion = selectRegion.any((element) => element.id == event.region.id);
    if (isSelectRegion) {
      selectRegion.removeWhere((element) => element.id == event.region.id);
    }

    emit(prefState.copyWith(selectRegion: selectRegion));
  }

  void _removeTown(RemoveTownEvent event, Emitter<CountriesState> emit) async {
    final prefState = state;
    if (prefState is! CountriesLoaded) {
      return;
    }

    final selectTown = prefState.selectTown.toList();
    final isSelectTown = selectTown.any((element) => element.id == event.town.id);
    if (isSelectTown) {
      selectTown.removeWhere((element) => element.id == event.town.id);
    }

    emit(prefState.copyWith(selectTown: selectTown));
  }

  void _changeRegion(ChangeRegionEvent event, Emitter<CountriesState> emit) async {
    final prefState = state;
    if (prefState is! CountriesLoaded) {
      return;
    }
    final selectRegion = prefState.selectRegion.toList();
    final isSelect = selectRegion.any((element) => element.id == event.region.id);
    if (isSelect) {
      selectRegion.removeWhere((element) => element.id == event.region.id);
    } else {
      selectRegion.add(event.region);
    }
    emit(prefState.copyWith(selectRegion: selectRegion));
  }

  void _changeTowns(ChangeTownEvent event, Emitter<CountriesState> emit) async {
    final prefState = state;
    if (prefState is! CountriesLoaded) {
      return;
    }
    final selectTown = prefState.selectTown.toList();
    final isSelect = selectTown.any((element) => element.id == event.town.id);
    if (isSelect) {
      selectTown.removeWhere((element) => element.id == event.town.id);
    } else {
      selectTown.add(event.town);
    }
    emit(prefState.copyWith(selectTown: selectTown));
  }

  void _getRegions(GetRegionEvent event, Emitter<CountriesState> emit) async {
    if (event.access != null) {
      final regions = await Repository().regions(event.access, event.countries);
      // List<Regions> allRegions = [];
      // allRegions.addAll(regions);
      // final combineRegions = allRegions;
      // log(combineRegions.length.toString());
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

  void _getAllRegions(GetAllRegionEvent event, Emitter<CountriesState> emit) async {
    if (event.access != null) {
      final regions = await Repository().allRegions(event.access, event.countries);
      log(regions.length.toString());
      final prefstate = state;
      if (prefstate is CountriesLoading) {
        emit(CountriesLoading());
      } else {
        if (prefstate is! CountriesLoaded) {
          emit(CountriesLoading());
        } else {
          emit(prefstate.copyWith(
            allRegion: regions,
          ));
        }
      }
    } else {
      emit(CountriesError());
    }
  }

  void _getAllTowns(GetAllTownsEvent event, Emitter<CountriesState> emit) async {
    if (event.access != null) {
      final towns = await Repository().allTowns(event.access, event.regions);

      final prefstate = state;
      if (prefstate is CountriesLoading) {
        emit(CountriesLoading());
      } else {
        if (prefstate is! CountriesLoaded) {
          emit(CountriesLoading());
        } else {
          emit(prefstate.copyWith(
            allTown: towns,
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
