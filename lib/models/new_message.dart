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
  });

  String from;
  String message;
  String fromName;

  factory NewMessageAnswer.fromJson(Map<String, dynamic> json) =>
      NewMessageAnswer(
        from: json["from"].toString(),
        fromName: json["from_name"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "message": message,
      };
}
