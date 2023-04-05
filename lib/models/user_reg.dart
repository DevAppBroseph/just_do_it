import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

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
  File? photo;
  bool? sex;
  bool? isEntity;
  List<File>? images;
  File? cv;
  List<dynamic>? groups;
  List<Activities>? activities;
  List<int>? activitiesDocument;
  int? id;
  List<ActivitiesInfo>? activitiesInfo;

  UserRegModel({
    this.phoneNumber,
    this.email,
    this.firstname,
    this.lastname,
    this.password,
    this.docType,
    this.docInfo,
    this.activity,
    this.region,
    this.country,
    this.photoLink,
    this.cvLink,
    this.photo,
    this.sex,
    this.isEntity,
    this.images,
    this.cv,
    this.groups,
    this.activities,
    this.activitiesDocument,
    this.id,
    this.activitiesInfo,
  });

  void copyWith(
      {String? phoneNumber,
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
      String? country,
      String? photoLink,
      String? cvLink,
      int? id,
      List<ActivitiesInfo>? activitiesInfo}) {
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.email = email ?? this.email;
    this.firstname = firstname ?? this.firstname;
    this.lastname = lastname ?? this.lastname;
    this.password = password ?? this.password;
    this.photo = photo ?? this.photo;
    this.sex = sex ?? this.sex;
    this.docType = docType ?? this.docType; //
    this.docInfo = docInfo ?? this.docInfo;
    this.isEntity = isEntity ?? this.isEntity;
    this.activity = activity ?? this.activity;
    this.images = images ?? this.images;
    this.cv = cv ?? this.cv;
    this.groups = groups ?? this.groups;
    this.activities = activities ?? this.activities;
    this.region = region ?? this.region;
    this.country = country ?? this.country;
    this.activitiesDocument = activitiesDocument ?? this.activitiesDocument;
    this.photoLink = photoLink ?? this.photoLink;
    this.cvLink = cvLink ?? this.cvLink;
    this.id = id ?? this.id;
    this.activitiesInfo = activitiesInfo ?? this.activitiesInfo;
  }

  factory UserRegModel.fromJson(Map<String, dynamic> data) {
    String? email = data['email'];
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
    String? activity = data['activity'];
    String? cvLink = data['CV'];
    int? id = data['id'];
    List<ActivitiesInfo> list = [];
    if (data['activities_info'] != null) {
      for (var element in data['activities_info']) {
        list.add(ActivitiesInfo.fromJson(element));
      }
    }
    return UserRegModel(
      email: email,
      phoneNumber: phoneNumber,
      firstname: firstname,
      lastname: lastname,
      groups: groups,
      photoLink: photoLink,
      sex: sex,
      region: region,
      docType: docType,
      docInfo: docInfo,
      country: country,
      isEntity: isEntity,
      activity: activity,
      cvLink: cvLink,
      id: id,
      activitiesInfo: list,
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
    data['region'] = region;
    data['country'] = country;
    data['is_entity'] = isEntity;
    data['activity'] = activity;
    //TODO Это для будущей логики отправки списка изображений

    // if (images != null) {
    //   List<MultipartFile> files = [];
    //   images!.forEach((element) {
    //     files.add(MultipartFile.fromFileSync(
    //       element.path,
    //       filename: element.path.split('/').last,
    //     ));
    //   });
    //   data['image'] = files;
    // }
    if (images != null) {
      if (images?.first != null) {
        data['image'] = MultipartFile.fromFileSync(
          images!.first.path,
          filename: images!.first.path.split('/').last,
        );
      }
    }
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

class Activities {
  int id;
  String? description;
  String? photo;
  List<Subcategory> subcategory;
  List<String> selectSubcategory = [];

  Activities(this.id, this.description, this.photo, this.subcategory);

  factory Activities.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    String? photo = data['photo'];
    List<Subcategory> subcategory = [];
    for (var element in data['subcategories']) {
      subcategory.add(Subcategory.fromJson(element));
    }
    return Activities(id, description, photo, subcategory);
  }
}

class Subcategory {
  int id;
  String? description;

  Subcategory({required this.id, required this.description});

  factory Subcategory.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    return Subcategory(id: id, description: description);
  }
}

class DocumentInfo {
  String? serial, documentNumber, whoGiveDocument, documentData;
  DocumentInfo(this.serial, this.documentNumber, this.whoGiveDocument,
      this.documentData);
  factory DocumentInfo.fromJson(String data) {
    List<String> list = data.split('\n');
    list.map((e) => e.split(' ').length > 1 ? e.split(' ')[1] : e);

    String? serial = list[0].split(':').last.replaceAll(' ', '');
    String? documentNumber = list[1].split(':').last.replaceAll(' ', '');
    String? whoGiveDocument = list[2].split(':').last != ' '
        ? list[2].split(':').last.substring(1, list[2].split(':').last.length)
        : '';

    String? documentData = list[3].split(':').last.replaceAll(' ', '');
    print(documentData);
    return DocumentInfo(serial, documentNumber, whoGiveDocument, documentData);
  }
  String toJson() {
    return 'Серия: $serial\nНомер: $documentNumber\nКем выдан: $whoGiveDocument\nДата выдачи: $documentData';
  }
}

String mapDocumentType(String value) {
  if (value == 'Паспорт РФ') {
    return 'Passport';
  } else if (value == 'Заграничный паспорт') {
    return 'International Passport';
  }
  return 'Resident_ID';
}

String reverseMapDocumentType(String value) {
  if (value == 'Passport') {
    return 'Паспорт РФ';
  } else if (value == 'International Passport') {
    return 'Заграничный паспорт';
  }
  return 'Резидент ID';
}
