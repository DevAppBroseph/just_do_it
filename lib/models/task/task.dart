import 'package:dio/dio.dart';
import 'package:just_do_it/models/answer.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/models/task/task_subcategory.dart';
import 'package:just_do_it/models/user_reg.dart';

class Task {
  int? id;
  bool? isTask;
  bool? isGraded;
  bool? isGradedNow;
  bool? isBanned;
  int? isLiked;
  String? lastUpgrade;
  String? banReason;
  Owner? owner;
  int? chatId;
  String name;
  String description;
  TaskCategory? category;
  TaskSubcategory? subcategory;
  String dateStart;
  String dateEnd;
  int priceFrom;
  TaskStatus status;
  int priceTo;
  List<Countries> countries;
  List<Regions> regions;
  List<ArrayImages>? files;
  Currency? currency;
  List<Town> towns;
  String? verifyStatus;
  List<Answer> answers;
  bool canAppellate;
  Task(
      {this.id,
      this.owner,
      this.isTask,
      this.isLiked,
      this.lastUpgrade,
      this.chatId,
      this.currency,
      this.isBanned,
      required this.name,
      required this.description,
      this.category,
      this.subcategory,
      this.banReason,
      required this.dateStart,
      required this.dateEnd,
      required this.priceFrom,
      required this.isGraded,
      this.isGradedNow,
      required this.priceTo,
      this.regions = const [],
      this.towns = const [],
      this.countries = const [],
      this.files,
        required this.canAppellate,
     required this.status,
      this.verifyStatus,
      this.answers = const []});

  factory Task.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = [];
    if (json['answers'] != null) {
      for (var element in json['answers']) {
        answers.add(Answer.fromJson(element));
      }
    }

    List<Regions> regions = [];
    if (json['regions'] != null) {
      for (var element in json['regions']) {
        regions.add(Regions.fromJson(element));
      }
    }
    List<Countries> countries = [];
    if (json['countries'] != null) {
      for (var element in json['countries']) {
        countries.add(Countries.fromJson(element));
      }
    }

    List<Town> towns = [];
    if (json['towns'] != null) {
      for (var element in json['towns']) {
        towns.add(Town.fromJson(element));
      }
    }

    List<ArrayImages> files = [];
    if (json['files'] != null) {
      for (var element in json['files']) {
        files.add(ArrayImages(element['file'], null, id: element['id']));
      }
    }

    return Task(
        id: json["id"],
        lastUpgrade: json['last_grade'],
        isGraded: json["is_graded"],
        isBanned: ((json["is_banned"]??false)||(json["verify_status"]=="Failed")),
        verifyStatus: json["verify_status"],
        banReason: json["ban_reason"],
        canAppellate: json["canApellate"],
        owner: Owner.fromJson(json["owner"]),
        isLiked: json["is_liked"],
        currency: Currency.fromJson(json['currency']),
        name: json["name"],
        description: json["description"],
        chatId: json["chat_id"],
        category: TaskCategory.fromJson(json['category']),
        subcategory: TaskSubcategory.fromJson(json["subcategory"]),
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        priceFrom: json["price_from"],
        priceTo: json["price_to"],
        isTask: json['as_customer'],
        status: TaskStatusX.fromString(json['status'],DateTime.parse(json["date_end"])),
        countries: countries,
        regions: regions,
        files: files,
        towns: towns,
        answers: answers,
         isGradedNow:  json["is_graded_now"],);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['subcategory'] = subcategory?.id;
    data['date_start'] = dateStart;
    data['date_end'] = dateEnd;
    data['price_from'] = priceFrom;
    data['is_liked'] = isLiked;
    data['price_to'] = priceTo;
    data['is_graded'] = isGraded;
    data['regions'] = regions.map((e) => e.id).toList();
    data['answers'] = answers.map((e) => e.id).toList();
    data['as_customer'] = isTask;
    data['currency'] = currency!.id;
    data['towns'] = towns.map((e) => e.id).toList();
    data['countries'] = countries.map((e) => e.id).toList();

    if (files != null) {
      List<MultipartFile> filesMultiDoc = [];
      for (var element in files!) {
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