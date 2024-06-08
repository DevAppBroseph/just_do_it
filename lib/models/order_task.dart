import 'package:just_do_it/models/review.dart';

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
  String? engName;
  String? name;
  String? shortName;

  Currency(this.isSelect,
      {required this.id,
      required this.name,
      required this.shortName,
      required this.engName});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(false,
        id: json['id'],
        name: json['name'],
        shortName: json['short_name'],
        engName: json['eng_name']);
  }
  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "short_name": shortName, 'eng_name': engName};
}

class Owner {
  int? id;
  String? firstname;
  String? lastname;
  String? photo;
  String? cv;
  int? isLiked;
  double? ranking;
  bool? isBanned;
  bool? isPassportExist;
  bool? isVerified;
  int? countOrdersCreate;
  String? activity;
  List<String> listPhoto;
  int? balance;
  List<OwnerActivities>? activities;
  int? countOrdersComplete;
  List<ReviewsDetail>? reviews;
  ReviewsDetail? lastReviews;
  bool? hasReview;
  Owner({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
    this.balance,
    this.cv,
    this.isBanned,
    this.ranking,
    this.activities,
    this.isPassportExist,
    this.isVerified,
    this.countOrdersCreate,
    this.activity,
    this.hasReview,
    this.isLiked,
    this.listPhoto = const [],
    this.countOrdersComplete,
    this.reviews,
    this.lastReviews,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    List<String> listPhoto = [];
    if (json['images'] != null) {
      for (var element in json['images']) {
        listPhoto.add(element['image']);
      }
    }
    List<OwnerActivities> activities = [];
    if (json['activities'] != null) {
      for (var element in json['activities']) {
        activities.add(OwnerActivities.fromJson(element));
      }
    }
    List<ReviewsDetail> reviews = [];
    if (json['reviews'] != null) {
      for (var element in json['reviews']) {
        reviews.add(ReviewsDetail.fromJson(element));
      }
    }
    return Owner(
      lastReviews: json['last_review'] == null
          ? null
          : ReviewsDetail.fromJson(json['last_review']),
      id: json["id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      photo: json["photo"],
      cv: json["CV"],
      hasReview: json['has_review'],
      activities: activities,
      balance: json["balance"],
      ranking: json["ranking"],
      isLiked: json["is_liked"],
      isBanned: json["is_banned"],
      isPassportExist: json["is_passport_exist"],
      isVerified: json["is_verified"],
      countOrdersCreate: json["count_orders_create"],
      activity: json["activity"],
      countOrdersComplete: json["count_orders_complete"],
      listPhoto: listPhoto,
      reviews: reviews,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "photo": photo,
        "is_liked": isLiked,
      };
}

class OwnerActivities {
  bool isSelect;
  int id;
  String? description;
  String? engDescription;
  String? photo;
  List<OwnerSubcategory> subcategory;
  List<String> selectSubcategory = [];

  OwnerActivities(this.isSelect, this.engDescription, this.id, this.description,
      this.photo, this.subcategory);

  factory OwnerActivities.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    String? engDescription = data['description_eng'];
    String? photo = data['photo'];
    List<OwnerSubcategory> subcategory = [];
    if (data['subcategories'] != null) {
      for (var element in data['subcategories']) {
        subcategory.add(OwnerSubcategory.fromJson(element));
      }
    }
    return OwnerActivities(
      false,
      engDescription,
      id,
      description,
      photo,
      subcategory,
    );
  }
}

class OwnerSubcategory {
  bool isSelect;
  int id;
  String? description;

  OwnerSubcategory(this.isSelect,
      {required this.id, required this.description});

  factory OwnerSubcategory.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    return OwnerSubcategory(false, id: id, description: description);
  }
}
