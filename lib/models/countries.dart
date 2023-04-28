class Countries {
  String? name;
  int? id;
  bool isSelect;

  Countries(
    this.isSelect,
    {
    required this.name,
    required this.id,
  });

  factory Countries.fromJson(Map<String, dynamic> json) {
    return Countries(
      false,
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
  bool isSelect;

  Regions(
    this.isSelect,
    {
    required this.name,
    required this.id,
  });

  factory Regions.fromJson(Map<String, dynamic> json) {
    return Regions(
      false,
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
  bool isSelect;

  Town(
    this.isSelect,
    {
    required this.name,
    required this.id,
  });

  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      false,
      name: json['name'],
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
