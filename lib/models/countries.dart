class Countries {
  String? name;
  String? engName;
  int? id;
  List<Regions> region;
  bool select;

  Countries({
    required this.name,
    required this.engName,
    required this.id,
    this.select = false,
    this.region = const [],
  });

  factory Countries.fromJson(Map<String, dynamic> json) {
    List<Regions> regions = [];
    if (json['regions'] != null) {
      for (var element in json['regions']) {
        regions.add(Regions.fromJson(element));
      }
    }

    return Countries(
      name: json['name'],
      id: json['id'],
      region: regions,
      engName: json['eng_name'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class Regions {
  String? name;
  String? engName;

  int? id;
  List<Town> town;
  bool select;

  Regions({
    required this.engName,
    required this.name,
    required this.id,
    this.select = false,
    this.town = const [],
  });
  factory Regions.fromJson(Map<String, dynamic> json) {
    List<Town> towns = [];
    if (json['towns'] != null) {
      for (var element in json['towns']) {
        towns.add(Town.fromJson(element));
      }
    }
    return Regions(
      name: json['name'],
      id: json['id'],
      town: towns,
      engName: json['eng_name'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class Town {
  String? name;
  String? engName;
  int? id;
  bool select;

  Town({
    required this.name,
    required this.engName,
    required this.id,
    this.select = false,
  });

  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      name: json['name'],
      id: json['id'],
      engName: json['eng_name'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
