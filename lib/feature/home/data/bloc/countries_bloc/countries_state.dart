part of 'countries_bloc.dart';

class CountriesState {}

class CountriesEmpty extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  List<Countries> country;
  List<Countries> selectCountry;
  List<Regions> region;
  List<Regions> selectRegion;
  List<Town> town;
  List<Town> selectTown;
  //  bool switchCountry;

  CountriesLoaded(
      {this.selectCountry = const [],
      this.selectRegion = const [],
      this.selectTown = const [],
      required this.region,
      required this.town,
      required this.country});
  CountriesLoaded copyWith({
    // bool? switchCountry,
    List<Regions>? selectRegion,
    List<Countries>? selectCountry,
    List<Town>? selectTown,
    List<Countries>? country,
    List<Regions>? region,
    List<Town>? town,
  }) {
    return CountriesLoaded(
        selectTown: selectTown ?? this.selectTown,
        selectRegion: selectRegion ?? this.selectRegion,
        selectCountry: selectCountry ?? this.selectCountry,
        region: region ?? this.region,
        town: town ?? this.town,
        country: country ?? this.country);
  }
}

class CountriesError extends CountriesState {}
