
part of 'countries_bloc.dart';

class CountriesState {}

class CountriesEmpty extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  final List<Countries>? country;


  CountriesLoaded({required this.country});
}

class CountriesError extends CountriesState {}

