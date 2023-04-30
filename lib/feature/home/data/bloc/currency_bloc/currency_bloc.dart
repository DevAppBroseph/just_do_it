import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/network/repository.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyLoading()) {
    on<GetCurrencyEvent>(_getCurrency);
  }
  List<Currency>? currency;

  void _getCurrency(GetCurrencyEvent event, Emitter<CurrencyState> emit) async {
    emit(CurrencyLoading());
    if (event.access != null) {
      currency = await Repository().currency(event.access);
      log(currency.toString());
      emit(CurrencyLoaded(currency: currency));
    } else {
      emit(CurrencyError());
    }
  }
}
