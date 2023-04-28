
part of 'countries_bloc.dart';

class CountriesState {}

class CountriesEmpty extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  final List<Countries> country;
  final List<Regions> region;
  final List<Town> town;

  CountriesLoaded({required this.region, required this.town, required this.country});

}

class CountriesError extends CountriesState {}


