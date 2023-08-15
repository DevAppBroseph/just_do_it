import 'package:just_do_it/models/favourites_info.dart';

class Answers {
  String? description;
  int? id;
  bool? isGraded;
  String? status;
  int? price;
  OwnerOrder? owner;
  int? chatId;

  Answers(
      {required this.description,
      required this.id,
      required this.status,
      required this.price,
      required this.isGraded,
      this.owner,
      this.chatId});

  factory Answers.fromJson(Map<String, dynamic> json) {
    return Answers(
      description: json['description'],
      id: json['id'],
      status: json['status'],
      chatId: json['chat_id'],
      price: json['price'],
      owner: json['owner'] == null ? null : OwnerOrder.fromJson(json['owner']),
      isGraded: json['is_graded'],
    );
  }
  Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        'status': status,
        "is_graded": isGraded,
        'price': price,
        // 'owner': owner,
      };
}
