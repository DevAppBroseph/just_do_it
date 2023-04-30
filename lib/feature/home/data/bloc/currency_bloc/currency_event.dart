part of 'currency_bloc.dart';

class CurrencyEvent {}

class GetCurrencyEvent extends CurrencyEvent {
  String? access;
  GetCurrencyEvent(this.access);
}

