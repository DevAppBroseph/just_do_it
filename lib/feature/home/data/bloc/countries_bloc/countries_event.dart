part of 'countries_bloc.dart';


class CountriesEvent {}

class GetCountryEvent extends CountriesEvent {
  String? access;
  GetCountryEvent(this.access);
}
class GetRegionEvent extends CountriesEvent {
  Countries countries;
  String? access;
  GetRegionEvent(this.access, this.countries);
}

class GetTownsEvent extends CountriesEvent {
  String? access;
  Regions regions;
  GetTownsEvent(this.access, this.regions);
}

class SwitchCountry extends CountriesEvent {
  SwitchCountry();
}


