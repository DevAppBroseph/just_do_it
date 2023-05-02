part of 'countries_bloc.dart';

class CountriesState {}

class CountriesEmpty extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  List<Countries> country;
  List<Countries> selectCountry;
  List<Regions> region;
  List<Regions> selectRegion;
  List<Regions> allRegion;
  List<Town> town;
  List<Town> selectTown;
  List<Town> allTown;
  //  bool switchCountry;

  CountriesLoaded(
      {
      this.allRegion = const [],
      this.allTown = const [],
      this.selectCountry = const [],
      this.selectRegion = const [],
      this.selectTown = const [],
      required this.region,
      required this.town,
      required this.country});
  CountriesLoaded copyWith({
    // bool? switchCountry,
    List<Regions>? allRegion,
    List<Town>? allTown,
    List<Regions>? selectRegion,
    List<Countries>? selectCountry,
    List<Town>? selectTown,
    List<Countries>? country,
    List<Regions>? region,
    List<Town>? town,
  }) {
    return CountriesLoaded(
       allTown: allTown ?? this.allTown,
        selectTown: selectTown ?? this.selectTown,
        selectRegion: selectRegion ?? this.selectRegion,
        allRegion: allRegion ?? this.allRegion,
        selectCountry: selectCountry ?? this.selectCountry,
        region: region ?? this.region,
        town: town ?? this.town,
        country: country ?? this.country);
  }
}

class CountriesUpdateState extends CountriesState {}

class CountriesError extends CountriesState {}
