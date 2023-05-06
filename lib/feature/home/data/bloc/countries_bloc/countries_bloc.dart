import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/network/repository.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc() : super(CountriesLoading()) {
    on<GetCountryEvent>(_getCountries);
  }

  List<Countries> country = [];

  void _getCountries(
      GetCountryEvent event, Emitter<CountriesState> emit) async {
    emit(CountriesLoading());
    country = await Repository().countries();
    emit(CountriesLoaded());
  }
}
