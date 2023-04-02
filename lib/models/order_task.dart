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

class Owner {
  int? id;
  String? firstname;
  String? lastname;
  String? photo;

  Owner({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "photo": photo,
      };
}
