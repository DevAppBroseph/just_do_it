import 'package:flutter/foundation.dart';
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
  String region;
  String? search;
  Uint8List? file;
  Currency? currency;

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
    required this.region,
    this.file,
    this.icon,
    this.task,
    this.search,
    this.typeLocation,
    this.whenStart,
    this.coast,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
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
        region: json["region"],
        search: json['search'],
        asCustomer: json['as_customer'],
       
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "subcategory": subcategory?.id,
        "date_start": dateStart,
        "date_end": dateEnd,
        "price_from": priceFrom,
        "price_to": priceTo,
        "region": region,
        'search': search,
        "as_customer": asCustomer,
        'currency': currency!.id
      };
}
