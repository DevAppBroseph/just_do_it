part of 'countries_bloc.dart';

class CountriesEvent {}

class GetCountryEvent extends CountriesEvent {}

class GetRegionEvent extends CountriesEvent {
  List<Countries> countries;
  GetRegionEvent(this.countries);
}

class GetTownsEvent extends CountriesEvent {
  List<Regions> regions;
  GetTownsEvent(this.regions);
}
