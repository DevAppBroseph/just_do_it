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

  void _getCountries(
      GetCountryEvent event, Emitter<CountriesState> emit) async {
    emit(CountriesLoading());
    country = await Repository().countries();
    emit(CountriesLoaded());
  }

  void _getRegions(GetRegionEvent event, Emitter<CountriesState> emit) async {
    List<Regions> regions = await Repository().regions(event.countries);
    for (var element in country) {
      if (event.countries.id == element.id) {
        element.region = regions;
        break;
      }
    }
    emit(CountriesUpdateState());
  }

  void _getTowns(GetTownsEvent event, Emitter<CountriesState> emit) async {
    List<Town> towns = await Repository().towns(event.regions);
    for (var element1 in country) {
      for (var element2 in element1.region) {
        if (element2.id == event.regions.id) {
          element2.town = towns;
          break;
        }
      }
    }
    emit(CountriesUpdateState());
  }
}
