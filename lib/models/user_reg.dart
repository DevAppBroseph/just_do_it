import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_category.dart';

class ArrayImages {
  int? id;
  String? linkUrl;
  Uint8List? byte;
  File? file;
  String? type;

  ArrayImages(this.linkUrl, this.byte, {this.file, this.id, this.type});
}

class UserRegModel {
  String? phoneNumber;
  String? email;
  String? firstname;
  String? lastname;
  String? password;
  String? docType;
  String? activity;
  String? region;
  String? country;
  String? photoLink;
  String? cvLink;
  String? docInfo;
  Uint8List? photo;
  bool? sex;
  bool? isEntity;
  String? verifyStatus;
  List<ArrayImages>? images;
  Uint8List? cv;
  bool? hasNotifications;
  String? cvType;
  bool? isBanned;
  String? banReason;
  bool? isButtonPressed;
  bool? rus;
  List<dynamic>? groups;
  List<TaskCategory>? activities;
  List<int>? activitiesDocument;
  List<Task>? ordersInProgressAsCustomer;
  List<Task>? ordersCompleteAsCustomer;
  List<Task>? myAnswersSelectedAsExecutor;
  List<Task>? ordersCompleteAsExecutor;
  int? id;
  List<ActivitiesInfo>? activitiesInfo;
  int? countMyAnswersAsExecutor;
  int? countOrdersInProgressAsCustomer;
  int? countOrdersCompleteACustomer;
  int? balance;
  int? allbalance;
  String? link;
  int? countOrderComplete;
  int? countMyAnswersSelectedAsExecutor;
  int? countOrdersCompleteAsExecutor;
  int? countOrdersCreateAsCustomer;
  List<Task>? ordersCreateAsCustomer;
  List<Task>? openOffers;
  List<Task>? selectedOffers;
  List<Task>? finishedOffers;
  List<Task>? selectedOffersAsCustomer;
  List<Task>? finishedOffersAsCustomer;
  List<Task>? myAnswersAsExecutor;
  bool? canAppellate;

  UserRegModel({
    this.countOrdersCreateAsCustomer,
    this.selectedOffers,
    this.myAnswersAsExecutor,
    this.finishedOffers,
    this.hasNotifications,
    this.selectedOffersAsCustomer,
    this.finishedOffersAsCustomer,
    this.openOffers,
    this.ordersCreateAsCustomer,
    this.phoneNumber,
    this.email,
     this.canAppellate,
    this.isButtonPressed,
    this.firstname,
    this.verifyStatus,
    this.lastname,
    this.password,
    this.docType,
    this.docInfo,
    this.activity,
    this.region,
    this.country,
    this.photoLink,
    this.isBanned,
    this.allbalance,
    this.cvLink,
    this.rus,
    this.photo,
    this.ordersCompleteAsExecutor,
    this.countOrdersCompleteAsExecutor,
    this.myAnswersSelectedAsExecutor,
    this.sex,
    this.isEntity,
    this.images,
    this.cv,
    this.countMyAnswersAsExecutor,
    this.countOrdersInProgressAsCustomer,
    this.ordersInProgressAsCustomer,
    this.ordersCompleteAsCustomer,
    this.countOrdersCompleteACustomer,
    this.countMyAnswersSelectedAsExecutor,
    this.cvType,
    this.groups,
    this.activities,
    this.activitiesDocument,
    this.id,
    this.activitiesInfo,
    this.balance,
    this.link,
    this.banReason,
    this.countOrderComplete,
  });

  void copyWith({
    String? phoneNumber,
    String? email,
    String? firstname,
    bool? isButtonPressed,
    bool? hasNotifications,
    String? lastname,
    String? password,
    int? allbalance,
    bool? canAppellate,
    String? verifyStatus,
    List<Task>? selectedOffers,
    List<Task>? finishedOffers,
    List<Task>? selectedOffersAsCustomerk,
    List<Task>? myAnswersAsExecutor,
    List<Task>? finishedOffersAsCustomer,
    int? countOrdersCreateAsCustomer,
    List<Task>? ordersCreateAsCustomer,
    List<Task>? openOffers,
    Uint8List? photo,
    bool? sex,
    String? docType,
    String? docInfo,
    int? countOrdersCompleteAsExecutor,
    int? countMyAnswersSelectedAsExecutor,
    int? countMyAnswersAsExecutor,
    bool? isEntity,
    String? activity,
    List<ArrayImages>? images,
    Uint8List? cv,
    String? cvType,
    bool? isBanned,
    List<Task>? ordersCompleteAsExecutor,
    List<Task>? ordersInProgressAsCustomer,
    List<Task>? ordersCompleteAsCustomer,
    List<dynamic>? groups,
    List<Task>? myAnswersSelectedAsExecutor,
    List<TaskCategory>? activities,
    List<int>? activitiesDocument,
    int? countOrdersCompleteACustomer,
    String? region,
    String? country,
    String? photoLink,
    String? cvLink,
    int? id,
    bool? rus,
    int? countOrdersInProgressAsCustomer,
    int? countOrderComplete,
    List<ActivitiesInfo>? activitiesInfo,
  }) {
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.isBanned = isBanned ?? this.isBanned;
    this.rus = rus ?? this.rus;
    this.isButtonPressed = isButtonPressed ?? this.isButtonPressed;
    this.verifyStatus = verifyStatus ?? this.verifyStatus;
    this.allbalance = allbalance ?? this.allbalance;
    this.hasNotifications = hasNotifications ?? this.hasNotifications;
    this.selectedOffers = selectedOffers ?? this.selectedOffers;
    this.finishedOffers = finishedOffers ?? this.finishedOffers;
    this.myAnswersAsExecutor = myAnswersAsExecutor ?? this.myAnswersAsExecutor;
    this.selectedOffersAsCustomer = selectedOffersAsCustomer ?? this.selectedOffersAsCustomer;
    this.finishedOffersAsCustomer = finishedOffersAsCustomer ?? this.finishedOffersAsCustomer;
    this.countOrdersCreateAsCustomer = countOrdersCreateAsCustomer ?? this.countOrdersCreateAsCustomer;
    this.openOffers = openOffers ?? this.openOffers;
    this.ordersCreateAsCustomer = ordersCreateAsCustomer ?? this.ordersCreateAsCustomer;
    this.email = email ?? this.email;
    this.firstname = firstname ?? this.firstname;
    this.lastname = lastname ?? this.lastname;
    this.password = password ?? this.password;
    this.photo = photo ?? this.photo;
    this.sex = sex ?? this.sex;
    this.docType = docType ?? this.docType;
    this.docInfo = docInfo ?? this.docInfo;
    this.isEntity = isEntity ?? this.isEntity;
    this.activity = activity ?? this.activity;
    this.images = images ?? this.images;
    this.ordersCompleteAsExecutor = ordersCompleteAsExecutor ?? this.ordersCompleteAsExecutor;
    this.cv = cv ?? this.cv;
    this.countMyAnswersAsExecutor = countMyAnswersAsExecutor ?? this.countMyAnswersAsExecutor;
    this.countOrdersCompleteAsExecutor = countOrdersCompleteAsExecutor ?? this.countOrdersCompleteAsExecutor;
    this.myAnswersSelectedAsExecutor = myAnswersSelectedAsExecutor ?? this.myAnswersSelectedAsExecutor;
    this.countOrdersCompleteACustomer = countOrdersCompleteACustomer ?? this.countOrdersCompleteACustomer;
    this.ordersInProgressAsCustomer = ordersInProgressAsCustomer ?? this.ordersInProgressAsCustomer;
    this.countMyAnswersSelectedAsExecutor = countMyAnswersSelectedAsExecutor ?? this.countMyAnswersSelectedAsExecutor;
    this.ordersCompleteAsCustomer = ordersCompleteAsCustomer ?? this.ordersCompleteAsCustomer;
    this.cvType = cvType ?? this.cvType;
    this.groups = groups ?? this.groups;
    this.activities = activities ?? this.activities;
    this.region = region ?? this.region;
    this.country = country ?? this.country;
    this.activitiesDocument = activitiesDocument ?? this.activitiesDocument;
    this.photoLink = photoLink ?? this.photoLink;
    this.cvLink = cvLink ?? this.cvLink;
    this.id = id ?? this.id;
    this.canAppellate = canAppellate ?? this.canAppellate;
    this.activitiesInfo = activitiesInfo ?? this.activitiesInfo;
    this.countOrderComplete = countOrderComplete ?? this.countOrderComplete;
    balance = balance ?? balance;
    link = link ?? link;
  }

  factory UserRegModel.fromJson(Map<String, dynamic> data) {
    String? email = data['email'];
    bool isBanned = data['is_banned'];
    bool isButtonPressed = data['is_button_pressed'];
    String? verifyStatus = data['verify_status'];
    int? countOrdersCreateAsCustomer = data['count_orders_create_as_customer'];
    int? countMyAnswersAsExecutor = data['count_my_answers_as_executor'];
    int? countOrdersCompleteAsExecutor = data['count_orders_complete_as_executor'];
    int? countOrdersInProgressAsCustomer = data['count_orders_in_progress_as_customer'];
    int? countMyAnswersSelectedAsExecutor = data['count_my_answers_selected_as_executor'];
    int? countOrdersCompleteACustomer = data['count_orders_complete_as_customer'];
    bool? hasNotifications = data['has_notifications'];
    int? countOrderComplete = data['count_orders_complete'];
    String? phoneNumber = data['phone_number'];
    String? firstname = data['firstname'];
    String? lastname = data['lastname'];
    List<dynamic>? groups = data['groups'];
    String? photoLink = data['photo'];
    bool? sex = data['sex'];
    String? region = data['region'];
    String? country = data['country'];
    String? docType = data['doc_type'];
    String? docInfo = data['doc_info'];
    bool? isEntity = data['is_entity'];
    bool? canAppellate = data['canApellate'];
    String? activity = data['activity'];
    String? cvLink = data['CV'];
    int? id = data['id'];
    bool? rus = data['rus'];
    List<ActivitiesInfo> list = [];
    int? balance = data['actual_balance'];
    int? allbalance = data['balance'];
    String? link = data['link'];
    String? banReason = data['failed_verify_reason'];
    if (data['activities_info'] != null) {
      for (var element in data['activities_info']) {
        list.add(ActivitiesInfo.fromJson(element));
      }
    }
    List<Task> listTaskOrdersInProgressAsCustomer = [];
    if (data['orders_in_progress_as_customer'] != null) {
      for (var element in data['orders_in_progress_as_customer']) {
        listTaskOrdersInProgressAsCustomer.add(Task.fromJson(element));
      }
    }
    List<Task> listMyAnswersAsExecutor = [];
    if (data['my_answers_as_executor'] != null) {
      for (var element in data['my_answers_as_executor']) {
        listMyAnswersAsExecutor.add(Task.fromJson(element));
      }
    }
    List<Task> listSelectedOffers = [];
    if (data['selected_offers'] != null) {
      for (var element in data['selected_offers']) {
        listSelectedOffers.add(Task.fromJson(element));
      }
    }
    List<Task> listFinishedOffers = [];
    if (data['finished_offers'] != null) {
      for (var element in data['finished_offers']) {
        listFinishedOffers.add(Task.fromJson(element));
      }
    }
    List<Task> listSelectedOffersAsCustomer = [];
    if (data['selected_offers_as_customer'] != null) {
      for (var element in data['selected_offers_as_customer']) {
        listSelectedOffersAsCustomer.add(Task.fromJson(element));
      }
    }
    List<Task> listFinishedOffersAsCustomer = [];
    if (data['finished_offers_as_customer'] != null) {
      for (var element in data['finished_offers_as_customer']) {
        listFinishedOffersAsCustomer.add(Task.fromJson(element));
      }
    }
    List<Task> listOpenOffers = [];
    if (data['open_offers'] != null) {
      for (var element in data['open_offers']) {
        listOpenOffers.add(Task.fromJson(element));
      }
    }
    List<Task> listOrdersCreateAsCustomer = [];
    if (data['orders_create_as_customer'] != null) {
      for (var element in data['orders_create_as_customer']) {
        listOrdersCreateAsCustomer.add(Task.fromJson(element));
      }
    }
    List<Task> listTaskOrdersCompleteAsCustomer = [];
    if (data['orders_complete_as_customer'] != null) {
      for (var element in data['orders_complete_as_customer']) {
        listTaskOrdersCompleteAsCustomer.add(Task.fromJson(element));
      }
    }
    List<Task> listMyAnswersSelectedAsExecutor = [];
    if (data['my_answers_selected_as_executor'] != null) {
      for (var element in data['my_answers_selected_as_executor']) {
        listMyAnswersSelectedAsExecutor.add(Task.fromJson(element));
      }
    }
    List<Task> listOrdersCompleteAsExecutor = [];
    if (data['orders_complete_as_executor'] != null) {
      for (var element in data['orders_complete_as_executor']) {
        listOrdersCompleteAsExecutor.add(Task.fromJson(element));
      }
    }
    List<ArrayImages> listImages = [];
    if (data['images'] != null) {
      for (var element in data['images']) {
        listImages.add(ArrayImages(element['image'], null, id: element['id']));
      }
    }
    return UserRegModel(
      openOffers: listOpenOffers,
      countOrderComplete: countOrderComplete,
      selectedOffersAsCustomer: listSelectedOffersAsCustomer,
      selectedOffers: listSelectedOffers,
      finishedOffers: listFinishedOffers,
      finishedOffersAsCustomer: listFinishedOffersAsCustomer,
      email: email,
      isButtonPressed: isButtonPressed,
      hasNotifications: hasNotifications,
      myAnswersAsExecutor: listMyAnswersAsExecutor,
      countMyAnswersSelectedAsExecutor: countMyAnswersSelectedAsExecutor,
      countOrdersInProgressAsCustomer: countOrdersInProgressAsCustomer,
      phoneNumber: phoneNumber,
      firstname: firstname,
      lastname: lastname,
      groups: groups,
      rus: rus,
      isBanned: isBanned,
      photoLink: photoLink,
      sex: sex,
      allbalance: allbalance,
      countOrdersCreateAsCustomer: countOrdersCreateAsCustomer,
      ordersCreateAsCustomer: listOrdersCreateAsCustomer,
      ordersCompleteAsExecutor: listOrdersCompleteAsExecutor,
      countOrdersCompleteAsExecutor: countOrdersCompleteAsExecutor,
      myAnswersSelectedAsExecutor: listMyAnswersSelectedAsExecutor,
      countOrdersCompleteACustomer: countOrdersCompleteACustomer,
      ordersInProgressAsCustomer: listTaskOrdersInProgressAsCustomer,
      ordersCompleteAsCustomer: listTaskOrdersCompleteAsCustomer,
      region: region,
      docType: docType,
      verifyStatus: verifyStatus,
      docInfo: docInfo,
      country: country,
      isEntity: isEntity,
      activity: activity,
      cvLink: cvLink,
      id: id,
      activitiesInfo: list,
      images: listImages,
      countMyAnswersAsExecutor: countMyAnswersAsExecutor,
      balance: balance,
      link: link, canAppellate: canAppellate??false,
      banReason: banReason??"NOREASON"
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['rus'] = rus;
    data['is_button_pressed'] = isButtonPressed;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['password'] = password;
    data['count_orders_complete'] = countOrderComplete;
    if (photo != null) {
      data['photo'] = MultipartFile.fromBytes(
        photo!,
        filename: '${DateTime.now()}.jpg',
      );
    } else {
      data['photo'] = null;
    }
    data['sex'] = sex;
    data['doc_type'] = docType;
    data['doc_info'] = docInfo;
    data['region'] = region;
    data['country'] = country;
    data['is_entity'] = isEntity;
    data['activity'] = activity;

    if (images != null) {
      List<MultipartFile> files = [];
      for (var element in images!) {
        if (element.byte != null) {
          files.add(
            MultipartFile.fromBytes(
              element.byte!,
              filename: '${DateTime.now()}.${element.type}',
            ),
          );
        } else {
          files.add(MultipartFile.fromString(element.id.toString()));
        }
      }

      data['images'] = files;
    }

    if (cv != null) {
      data['CV'] = MultipartFile.fromBytes(
        cv!,
        filename: '${DateTime.now()}.$cvType',
      );
    }
    data['groups'] = groups;
    if (activitiesDocument != null) data['activities'] = activitiesDocument;

    return data;
  }
}

class ActivitiesInfo {
  int? id;
  String? description;
  String? photo;

  ActivitiesInfo(this.id, this.description, this.photo);

  factory ActivitiesInfo.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    String? photo = data['photo'];

    return ActivitiesInfo(id, description, photo);
  }
}





class DocumentInfo {
  String? serial, documentNumber, whoGiveDocument, documentData;
  DocumentInfo(this.serial, this.documentNumber, this.whoGiveDocument, this.documentData);
  factory DocumentInfo.fromJson(String data) {
    List<String> list = data.split('\n');
    list.map((e) => e.split(' ').length > 1 ? e.split(' ')[1] : e);

    String? serial = list[0].split(':').last.replaceAll(' ', '');
    String? documentNumber = list[1].split(':').last.replaceAll(' ', '');
    String? whoGiveDocument =
        list[2].split(':').last != ' ' ? list[2].split(':').last.substring(1, list[2].split(':').last.length) : '';

    String? documentData = list[3].split(':').last.replaceAll(' ', '');
    return DocumentInfo(serial, documentNumber, whoGiveDocument, documentData);
  }
  String toJson() {
    return 'Серия: $serial\nНомер: $documentNumber\nКем выдан: $whoGiveDocument\nДата выдачи: $documentData';
  }
}

String mapDocumentType(String value) {
  if (value == 'passport_of_the_RF'.tr()) {
    return 'Passport';
  } else if (value == 'foreign_passport'.tr()) {
    return 'International Passport';
  }
  return 'Resident_ID';
}

String reverseMapDocumentType(String value) {
  if (value == 'Passport') {
    return 'passport_of_the_RF'.tr();
  } else if (value == 'International Passport') {
    return 'foreign_passport'.tr();
  }
  return 'resident_ID'.tr();
}
