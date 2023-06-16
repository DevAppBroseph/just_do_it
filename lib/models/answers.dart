import 'package:just_do_it/models/favourites_info.dart';

class Answers {
  String? description;
  int? id;
  String? status;
  int? price;
  OwnerOrder? owner;
  int? chatId;

  Answers(
      {required this.description,
      required this.id,
      required this.status,
      required this.price,
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
    );
  }
  Map<String, dynamic> toJson() => {
        "description": description,
        "id": id,
        'status': status,
        'price': price,
        // 'owner': owner,
      };
}
