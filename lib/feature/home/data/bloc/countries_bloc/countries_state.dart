
part of 'countries_bloc.dart';

class CountriesState {}

class CountriesEmpty extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
   List<Countries> country;
   List<Regions> region;
   List<Town> town;
   bool switchCountry;

  CountriesLoaded({required this.switchCountry, required this.region, required this.town, required this.country});
  CountriesLoaded copyWith(
  { 
  bool? switchCountry,
  List<Countries>? country,
  List<Regions>? region,
  List<Town>? town,}
  
  ){
    return CountriesLoaded(switchCountry: switchCountry ?? this.switchCountry, region: region ?? this.region, town: town ?? this.town, country: country ?? this.country);
    
  }

}

class CountriesError extends CountriesState {}


