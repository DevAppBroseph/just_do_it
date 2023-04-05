// class Chat {
//   String? image;
//   String date;
//   String name;
//   String message;
//   String typeWork;
//
//   Chat({
//     this.image,
//     required this.date,
//     required this.name,
//     required this.message,
//     required this.typeWork,
//   });
// }

class Chat {
  Chat({
    required this.chatWith,
    required this.messagesList,
  });

  ChatWith chatWith;
  List<Message> messagesList;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatWith: ChatWith.fromJson(json["chat_with"]),
        messagesList: List<Message>.from(
            json["messages_list"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chat_with": chatWith.toJson(),
        "messages_list":
            List<dynamic>.from(messagesList.map((x) => x.toJson())),
      };
}

class ChatWith {
  ChatWith({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.photo,
  });

  int id;
  String firstname;
  String lastname;
  String? photo;

  factory ChatWith.fromJson(Map<String, dynamic> json) => ChatWith(
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

class Message {
  Message({
    required this.id,
    required this.time,
    required this.text,
    required this.sender,
  });

  int id;
  DateTime time;
  String text;
  ChatWith sender;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        time: DateTime.parse(json["time"]),
        text: json["text"],
        sender: ChatWith.fromJson(json["sender"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time.toIso8601String(),
        "text": text,
        "sender": sender.toJson(),
      };
}

class ChatList {
  ChatList({
    required this.id,
    required this.chatWith,
    required this.lastMsg,
  });

  int id;
  ChatWith chatWith;
  LastMsg lastMsg;

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
        id: json["id"],
        chatWith: ChatWith.fromJson(json["chat_with"]),
        lastMsg: LastMsg.fromJson(json["last_msg"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chat_with": chatWith.toJson(),
        "last_msg": lastMsg.toJson(),
      };
}

class LastMsg {
  LastMsg({
    required this.id,
    required this.time,
    required this.text,
    required this.sender,
  });

  int id;
  DateTime time;
  String text;
  ChatWith sender;

  factory LastMsg.fromJson(Map<String, dynamic> json) => LastMsg(
        id: json["id"],
        time: DateTime.parse(json["time"]),
        text: json["text"],
        sender: ChatWith.fromJson(json["sender"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time.toIso8601String(),
        "text": text,
        "sender": sender.toJson(),
      };
}
