import 'dart:developer';

import 'package:dio/dio.dart';
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
  List<ArrayImages>? files;
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
    this.files,
    this.icon,
    this.task,
    this.typeLocation,
    this.whenStart,
    this.coast,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    log('message Task.fromJson $json');
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

    List<ArrayImages> files = [];
    for (var element in json['files']) {
      files.add(ArrayImages(element['file'], null, id: element['id']));
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
        asCustomer: json['as_customer'],
        countries: countries,
        regions: regions,
        files: files,
        towns: towns);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['subcategory'] = subcategory?.id;
    data['date_start'] = dateStart;
    data['date_end'] = dateEnd;
    data['price_from'] = priceFrom;
    data['price_to'] = priceTo;
    data['regions'] = regions.map((e) => e.id).toList();
    data['as_customer'] = asCustomer;
    data['currency'] = currency!.id;
    data['towns'] = towns.map((e) => e.id).toList();
    data['countries'] = countries.map((e) => e.id).toList();

    if (files != null) {
      List<MultipartFile> filesMultiDoc = [];
      for (var element in files!) {
        log('message ${element.type} ${element.byte == null}');
        if (element.byte != null) {
          filesMultiDoc.add(
            MultipartFile.fromBytes(
              element.byte!,
              filename: '${DateTime.now()}.${element.type!}',
            ),
          );
        } else {
          filesMultiDoc.add(MultipartFile.fromString(element.id.toString()));
        }
      }

      data['files'] = filesMultiDoc;
    }

    return data;
  }
}
