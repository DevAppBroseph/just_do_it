class MessageToSupport {
  String? email;
  String? title;
  String? text;

  MessageToSupport({
    required this.email,
    required this.title,
    required this.text,

  });

  factory MessageToSupport.fromJson(Map<String, dynamic> json) {
    return MessageToSupport(
      email: json['email'],
      title: json['title'],
      text: json['text'],
    
    );
  }
  Map<String, dynamic> toJson() => {
        "email": email,
        "title": title,
        'text': text,
    
      };
}
