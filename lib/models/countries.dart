class Countries {
  String? name;
  int? id;


  Countries({
    required this.name,
    required this.id,
  });

  factory Countries.fromJson(Map<String, dynamic> json) {
    
    return Countries(
      name: json['name'],
      id: json['id'],
    );
  }
    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}