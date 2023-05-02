import 'package:flutter/foundation.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/user_reg.dart';

class Task {
  int? id;
  bool? asCustomer;
  Owner? owner;
  int? chatId;
  String name;
  String description;
  Activities? activities;
  Subcategory? subcategory;
  String dateStart;
  String dateEnd;
  int priceFrom;
  int priceTo;
  List<Countries> countries;
  List<Regions> regions;
  String? search;
  Uint8List? file;
  Currency? currency;
  List<Town> towns;
  String? icon;
  String? task;
  String? typeLocation;
  String? whenStart;
  String? coast;

  Task({
    this.id,
    this.owner,
    this.asCustomer,
    this.chatId,
    this.currency,
    required this.name,
    required this.description,
    this.activities,
    this.subcategory,
    required this.dateStart,
    required this.dateEnd,
    required this.priceFrom,
    required this.priceTo,
    this.regions = const [],
    this.towns = const [],
    this.countries = const [],
    this.file,
    this.icon,
    this.task,
    this.search,
    this.typeLocation,
    this.whenStart,
    this.coast,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    List<Regions> regions = [];
    for (var element in json['regions']) {
      regions.add(Regions.fromJson(element));
    }
    List<Countries> countries = [];
    for (var element in json['countries']) {
      countries.add(Countries.fromJson(element));
    }
    List<Town> towns = [];
    for (var element in json['towns']) {
      towns.add(Town.fromJson(element));
    }

    return Task(
        id: json["id"],
        owner: Owner.fromJson(json["owner"]),
        currency: Currency.fromJson(json['currency']),
        name: json["name"],
        description: json["description"],
        chatId: json["chat_id"],
        activities: Activities.fromJson(json['category']),
        subcategory: Subcategory.fromJson(json["subcategory"]),
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        priceFrom: json["price_from"],
        priceTo: json["price_to"],
        search: json['search'],
        asCustomer: json['as_customer'],
        countries: countries,
        regions: regions,
        towns: towns);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "subcategory": subcategory?.id,
        "date_start": dateStart,
        "date_end": dateEnd,
        "price_from": priceFrom,
        "price_to": priceTo,
        "regions": regions.map((e) => e.id).toList(),
        'search': search,
        "as_customer": asCustomer,
        'currency': currency!.id,
        'towns': towns.map((e) => e.id).toList(),
        'countries': countries.map((e) => e.id).toList(),
      };
}
