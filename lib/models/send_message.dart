// To parse this JSON data, do
//
//     final sendMessage = sendMessageFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

SendMessage sendMessageFromJson(String str) =>
    SendMessage.fromJson(json.decode(str));

String sendMessageToJson(SendMessage data) => json.encode(data.toJson());

class SendMessage {
  SendMessage({
    required this.from,
    required this.message,
    required this.time,
  });

  String from;
  String message;
  DateTime? time;

  factory SendMessage.fromJson(Map<String, dynamic> json) => SendMessage(
        from: json["from"].toString(),
        message: json["message"],
        time: json["time"] != null
            ? DateFormat("yyyy-MM-ddThh:mm:ss").parse(json["time"], true)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "to": from,
        "message": message,
      };
}
