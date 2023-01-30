import 'package:flutter/services.dart';

class UserRegModel {
  String? phoneNumber;
  String? email;
  String? firstname;
  String? lastname;
  String? password;
  Uint8List? photo;
  String? sex;
  String? docType;
  String? docInfo;
  bool? isEntity;
  String? activity;
  Uint8List? image;
  Uint8List? cv;
  List<String>? groups;

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
    this.image,
    this.cv,
    this.groups,
  });

  void copyWith({
    String? phoneNumber,
    String? email,
    String? firstname,
    String? lastname,
    String? password,
    Uint8List? photo,
    String? sex,
    String? docType,
    String? docInfo,
    bool? isEntity,
    String? activity,
    Uint8List? image,
    Uint8List? cv,
    List<String>? groups,
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
    this.image = image ?? this.image;
    this.cv = cv ?? this.cv;
    this.groups = groups ?? this.groups;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['password'] = password;
    data['photo'] = photo;
    data['sex'] = sex;
    data['doc_type'] = docType;
    data['doc_info'] = docInfo;
    data['is_entity'] = isEntity;
    data['activity'] = activity;
    data['image'] = image;
    data['CV'] = cv;
    data['groups'] = groups;
    return data;
  }
}
