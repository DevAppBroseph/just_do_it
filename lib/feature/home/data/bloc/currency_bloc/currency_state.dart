part of 'currency_bloc.dart';




class CurrencyState {}

class CurrencyEmpty extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final List<Currency>? currency;

  CurrencyLoaded({required this.currency});
}

class CurrencyError extends CurrencyState {}


