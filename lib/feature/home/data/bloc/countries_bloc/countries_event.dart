part of 'countries_bloc.dart';

class CountriesEvent {}

class GetCountryEvent extends CountriesEvent {
  String? access;
  GetCountryEvent(this.access);
}

class GetRegionEvent extends CountriesEvent {
  List<Countries> countries;
  String? access;
  GetRegionEvent(this.access, this.countries);
}

class GetTownsEvent extends CountriesEvent {
  String? access;
  List<Regions> regions;
  GetTownsEvent(this.access, this.regions);
}
