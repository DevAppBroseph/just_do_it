class NotificationsOnDevice {
  String? text;
  int? id;
  String? dateTime;
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
      dateTime: json['image'],
      unread: json['is_available'],

    );
  }
  Map<String, dynamic> toJson() => {
        "name": text,
        "must_coins": id,
        'image': dateTime,
        'is_available': unread,
    
      };
}
