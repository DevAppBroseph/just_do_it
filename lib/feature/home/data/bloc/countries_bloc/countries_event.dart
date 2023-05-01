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
class GetAllRegionEvent extends CountriesEvent {
  List<Countries> countries;
  String? access;
  GetAllRegionEvent(this.access, this.countries);
}
class ChangeCountryEvent extends CountriesEvent {
  Countries countries;
  ChangeCountryEvent(this.countries);
}
class ChangeRegionEvent extends CountriesEvent {
  Regions region;
  ChangeRegionEvent(this.region);
}
class ChangeTownEvent extends CountriesEvent {
  Town town;
  ChangeTownEvent(this.town);
}
class RemoveTownEvent extends CountriesEvent {
  Town town;
 
  RemoveTownEvent(this.town);
}
class RemoveCountryEvent extends CountriesEvent {
  Countries countries;
 
  RemoveCountryEvent(this.countries);
}

class RemoveRegionEvent extends CountriesEvent {
 Regions region;
 
  RemoveRegionEvent(this.region);
}


class GetAllTownsEvent extends CountriesEvent {
  String? access;
  List <Regions> regions;
  GetAllTownsEvent(this.access, this.regions);
}


class GetTownsEvent extends CountriesEvent {
  String? access;
  Regions regions;
  GetTownsEvent(this.access, this.regions);
}

class SwitchCountry extends CountriesEvent {
  SwitchCountry();
}


