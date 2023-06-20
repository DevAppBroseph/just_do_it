// To parse this JSON data, do
//
//     final newMessageAnswer = newMessageAnswerFromJson(jsonString);

import 'dart:convert';

NewMessageAnswer newMessageAnswerFromJson(String str) =>
    NewMessageAnswer.fromJson(json.decode(str));

String newMessageAnswerToJson(NewMessageAnswer data) =>
    json.encode(data.toJson());

class NewMessageAnswer {
  NewMessageAnswer({
    required this.from,
    required this.fromName,
    required this.message,
    required this.id,
    required this.idWithChat,
    required this.image,
  });

  String from;
  String message;
  String fromName;
  String? id;
  String? idWithChat;
  String? image;

  factory NewMessageAnswer.fromJson(Map<String, dynamic> json) =>
      NewMessageAnswer(
        from: json["from"].toString(),
        fromName: json["from_name"] ,
        message: json["message"],
        id: json["id"] != null ? json["id"].toString() : null,
        idWithChat: json["id_with_chat"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "message": message,
      };
}
