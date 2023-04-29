import 'dart:developer';

class OrderTask {
  int? id;
  int? chatId;
  String? name;
  String? description;
  Owner? owner;

  OrderTask({
    this.id,
    this.chatId,
    this.name,
    this.description,
    this.owner,
  });
  

  factory OrderTask.fromJson(Map<String, dynamic> json) => OrderTask(
        id: json["id"],
        chatId: json["chat_id"],
        name: json["name"],
        description: json["description"],
        owner: Owner.fromJson(json["owner"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "owner": owner,
      };
}

class Currency {
  bool isSelect;
  int? id;
  String? name;
  String? shortName;

  Currency(this.isSelect, {required this.id, required this.name, required this.shortName});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      false,
     id: json['id'],
     name: json['name'],
     shortName: json['short_name']
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_name": shortName,
      };
}


class Owner {
  int? id;
  String? firstname;
  String? lastname;
  String? photo;
  String? cv;
  String? ranking;
  bool? isPassportExist;
  int? countOrdersCreate;
  String? activity;
  List<String> listPhoto;

  Owner({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
    this.cv,
    this.ranking,
    this.isPassportExist,
    this.countOrdersCreate,
    this.activity,
    this.listPhoto = const [],
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    List<String> listPhoto = [];
    if (json['images'] != null) {
      for (var element in json['images']) {
        listPhoto.add(element['image']);
      }
    }
    return Owner(
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      photo: json["photo"],
      cv: json["CV"],
      ranking: json["ranking"],
      isPassportExist: json["is_passport_exist"],
      countOrdersCreate: json["count_orders_create"],
      activity: json["activity"],
      listPhoto: listPhoto,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "photo": photo,
      };
}
