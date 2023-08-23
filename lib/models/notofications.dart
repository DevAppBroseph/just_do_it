class NotificationsOnDevice {
  String? text;
  String? engMessage;
  int? id;
  DateTime? dateTime;
  bool? unread;

  NotificationsOnDevice({
    required this.text,
    required this.engMessage,
    required this.id,
    required this.dateTime,
    required this.unread,
  });

  factory NotificationsOnDevice.fromJson(Map<String, dynamic> json) {
    return NotificationsOnDevice(
      text: json['text'],
      engMessage: json['eng_text'],
      id: json['id'],
      dateTime: DateTime.parse(json['datetime']),
      unread: json['unread'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": text,
        'eng_text': engMessage,
        "must_coins": id,
        'datetime': dateTime,
        'unread': unread,
      };
}
