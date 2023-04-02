class ChatList {
  int? id;
  ChatWith? chatWith;
  LastMsg? lastMsg;

  ChatList({
    required this.id,
    required this.chatWith,
    required this.lastMsg,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
        id: json['id'],
        chatWith: ChatWith.fromJson(json['chat_with']),
        lastMsg: LastMsg.fromJson(json['last_msg']),
      );
}

class ChatWith {
  String? firstname;
  String? lastname;
  dynamic photo;

  ChatWith({
    required this.firstname,
    required this.lastname,
    required this.photo,
  });

  factory ChatWith.fromJson(Map<String, dynamic> json) => ChatWith(
        firstname: json['firstname'],
        lastname: json['lastname'],
        photo: json['photo'],
      );
}

class LastMsg {
  String? time;
  String? text;
  Sender? sender;

  LastMsg({
    required this.time,
    required this.text,
    required this.sender,
  });

  factory LastMsg.fromJson(Map<String, dynamic> json) => LastMsg(
        time: json['time'],
        text: json['text'],
        sender: Sender.fromJson(json['sender']),
      );
}

class Sender {
  int? id;
  String? firstname;
  String? lastname;
  dynamic photo;

  Sender({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        photo: json['photo'],
      );
}
