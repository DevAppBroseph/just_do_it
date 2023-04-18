class Levels {
  String? name;
  int? mustCoins;
  String? image;
  bool? isAvailable;

  Levels({
    required this.name,
    required this.mustCoins,
    required this.image,
    required this.isAvailable,
  });

  factory Levels.fromJson(Map<String, dynamic> json) {
    
    return Levels(
      name: json['name'],
      mustCoins: json['must_coins'],
      image: json['image'],
      isAvailable: json['is_available'],
    );
  }
    Map<String, dynamic> toJson() => {
        "name": name,
        "must_coins": mustCoins,
        'image': image,
        'is_available': isAvailable,
      };
}