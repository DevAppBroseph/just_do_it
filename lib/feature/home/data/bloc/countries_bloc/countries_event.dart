part of 'countries_bloc.dart';

class CountriesEvent {}

class GetCountryEvent extends CountriesEvent {}

class GetRegionEvent extends CountriesEvent {
  Countries countries;
  GetRegionEvent(this.countries);
}

class GetTownsEvent extends CountriesEvent {
  Regions regions;
  GetTownsEvent(this.regions);
}

// class ResetCountryEvent extends CountriesEvent {}
