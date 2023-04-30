class Countries {
  String? name;
  int? id;

  Countries(
    {
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

class Regions {
  String? name;
  int? id;

  Regions(
    {
    required this.name,
    required this.id,
  });
  factory Regions.fromJson(Map<String, dynamic> json) {
    return Regions(
      name: json['name'],
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class Town {
  String? name;
  int? id;

  Town(
    {
    required this.name,
    required this.id,
  });

  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      name: json['name'],
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
