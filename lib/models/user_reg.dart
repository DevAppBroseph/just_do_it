import 'dart:io';

import 'package:dio/dio.dart';

class UserRegModel {
  String? phoneNumber;
  String? email;
  String? firstname;
  String? lastname;
  String? password;
  File? photo;
  bool? sex;
  String? docType;
  String? docInfo;
  bool? isEntity;
  String? activity;
  List<File>? images;
  File? cv;
  List<dynamic>? groups;
  List<Activities>? activities;
  String? region;
  List<int>? activitiesDocument;

  UserRegModel({
    this.phoneNumber,
    this.email,
    this.firstname,
    this.lastname,
    this.password,
    this.photo,
    this.sex,
    this.docType,
    this.docInfo,
    this.isEntity,
    this.activity,
    this.images,
    this.cv,
    this.groups,
    this.activities,
    this.region,
    this.activitiesDocument,
  });

  void copyWith({
    String? phoneNumber,
    String? email,
    String? firstname,
    String? lastname,
    String? password,
    File? photo,
    bool? sex,
    String? docType,
    String? docInfo,
    bool? isEntity,
    String? activity,
    List<File>? images,
    File? cv,
    List<dynamic>? groups,
    List<Activities>? activities,
    List<int>? activitiesDocument,
    String? region,
  }) {
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
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
    this.cv = cv ?? this.cv;
    this.groups = groups ?? this.groups;
    this.activities = activities ?? this.activities;
    this.region = region ?? this.region;
    this.activitiesDocument = activitiesDocument ?? this.activitiesDocument;
  }

  factory UserRegModel.fromJson(Map<String, dynamic> data) {
    String? email = data['email'];
    String? phoneNumber = data['phone_number'];
    String? firstname = data['firstname'];
    String? lastname = data['lastname'];
    List<dynamic>? groups = data['groups'];
    File? photo = data['photo'];
    bool? sex = data['sex'];
    String? region = data['region'];
    String? docType = data['doc_type'];
    String? docInfo = data['doc_info'];
    bool? isEntity = data['is_entity'];
    String? activity = data['activity'];
    File? cv = data['CV'];
    return UserRegModel(
      email: email,
      phoneNumber: phoneNumber,
      firstname: firstname,
      lastname: lastname,
      groups: groups,
      photo: photo,
      sex: sex,
      region: region,
      docType: docType,
      docInfo: docInfo,
      isEntity: isEntity,
      activity: activity,
      cv: cv,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['password'] = password;
    if (photo != null) {
      data['photo'] = MultipartFile.fromFileSync(
        photo!.path,
        filename: photo!.path.split('/').last,
      );
    }
    data['sex'] = sex;
    data['doc_type'] = docType;
    data['doc_info'] = docInfo;
    data['is_entity'] = isEntity;
    data['activity'] = activity;
    data['image'] = images;
    if (cv != null) {
      data['CV'] = MultipartFile.fromFileSync(
        cv!.path,
        filename: cv!.path.split('/').last,
      );
    }
    data['groups'] = groups;
    if (activitiesDocument != null) data['activities'] = activitiesDocument;
    return data;
  }
}

class Activities {
  int id;
  String? description;

  Activities(this.id, this.description);

  factory Activities.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    return Activities(id, description);
  }
}
