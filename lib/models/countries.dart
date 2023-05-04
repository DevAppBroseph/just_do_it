class Countries {
  String? name;
  int? id;
  List<Regions> region;
  bool select;

  Countries({
    required this.name,
    required this.id,
    this.select = false,
    this.region = const [],
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
  List<Town> town;
  bool select;

  Regions({
    required this.name,
    required this.id,
    this.select = false,
    this.town = const [],
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
  bool select;

  Town({
    required this.name,
    required this.id,
    this.select = false,
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
