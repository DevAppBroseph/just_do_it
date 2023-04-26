class CountriesEvent {}

class GetCountryEvent extends CountriesEvent {
  String? access;
  GetCountryEvent(this.access);
}

