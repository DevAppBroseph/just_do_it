import 'package:just_do_it/models/favourites_info.dart';

class Answer {
  String? description;
  int? id;
  bool? isGraded;
  String? status;
  int? price;
  OwnerOrder? owner;
  int? chatId;
  DateTime createdAt;
  Answer(
      {required this.description,
      required this.id,
      required this.status,
      required this.price,
      required this.isGraded,
        required this.createdAt,
      this.owner,
      this.chatId});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      description: json['description'],
      id: json['id'],
      status: json['status'],
      chatId: json['chat_id'],
      price: json['price'],
      owner: json['owner'] == null ? null : OwnerOrder.fromJson(json['owner']),
      isGraded: json['is_graded'],
      createdAt: DateTime.parse(json['created_at']),
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
