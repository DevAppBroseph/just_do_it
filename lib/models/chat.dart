class ChatList {
  int? id;
  ChatWith? chatWith;
  LastMsg? lastMsg;
  int? countUnreadMessage;
  int? category;
  ChatList(
      {required this.id,
      required this.chatWith,
      required this.lastMsg,
      required this.countUnreadMessage,
      this.category});

  factory ChatList.fromJson(Map<String, dynamic> json) {
    int? categoryId;
    if (json['category_id'] != null) {
      categoryId = int.tryParse(json['category_id'].toString());
    }
    if (json['category'] != null) {
      categoryId = int.tryParse(json['category'].toString());
    }
    return ChatList(
      id: json['id'],
      chatWith: ChatWith.fromJson(json['chat_with']),
      lastMsg: LastMsg.fromJson(json['last_msg']),
      countUnreadMessage: json['count_unread_messages'],
      category: categoryId,
    );
  }
}

class ChatWith {
  int? id;
  String? firstname;
  String? lastname;
  dynamic photo;

  ChatWith({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
  });

  factory ChatWith.fromJson(Map<String, dynamic> json) => ChatWith(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        photo: json['photo'],
      );

  String get fullName => '$firstname $lastname';
}

class LastMsg {
  DateTime? time;
  String? text;
  Sender? sender;
  bool? unread;

  LastMsg({
    required this.time,
    required this.text,
    required this.sender,
    required this.unread,
  });

  factory LastMsg.fromJson(Map<String, dynamic> json) => LastMsg(
        time: DateTime.parse(json['time']),
        text: json['text'],
        sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
        unread: json['unread'],
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
