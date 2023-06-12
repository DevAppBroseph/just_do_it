import 'package:just_do_it/models/favourites_info.dart';

class Answers {
  String? description;
  int? id;
  String? status;
  int? price;
  OwnerOrder? owner;

  Answers({
    required this.description,
    required this.id,
    required this.status,
    required this.price,
    this.owner,
  });

  factory Answers.fromJson(Map<String, dynamic> json) {
    
    return Answers(
      description: json['description'],
      id: json['id'],
      status: json['status'],
      price: json['price'],
      owner: OwnerOrder.fromJson(json['owner']),
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