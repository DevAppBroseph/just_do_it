import 'dart:convert';

NewMessageAnswerTask newMessageAnswerFromJson(String str) => NewMessageAnswerTask.fromJson(json.decode(str));

String newMessageAnswerToJson(NewMessageAnswerTask data) => json.encode(data.toJson());

class NewMessageAnswerTask {
  NewMessageAnswerTask({
    required this.action,
    required this.message,
    required this.id,
  });

  String message;
  String action;
  String? id;

  factory NewMessageAnswerTask.fromJson(Map<String, dynamic> json) => NewMessageAnswerTask(
        action: json["action"],
        message: json["message"],
        id: json["order_id"] != null ? json["id"].toString() : null,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
