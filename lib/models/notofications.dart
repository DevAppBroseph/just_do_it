class NotificationsOnDevice {
  String? text;
  int? id;
  DateTime? dateTime;
  bool? unread;

  NotificationsOnDevice({
    required this.text,
    required this.id,
    required this.dateTime,
    required this.unread,
  });

  factory NotificationsOnDevice.fromJson(Map<String, dynamic> json) {
    return NotificationsOnDevice(
      text: json['text'],
      id: json['id'],
      dateTime: DateTime.parse(json['datetime']),
      unread: json['unread'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": text,
        "must_coins": id,
        'datetime': dateTime,
        'unread': unread,
      };
}
