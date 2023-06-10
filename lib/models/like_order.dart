class FavouritesOrder {
  int? order;

  FavouritesOrder({
    required this.order,
  });

  factory FavouritesOrder.fromJson(Map<String, dynamic> json) {
    return FavouritesOrder(
      order: json['order'],
    );
  }
  Map<String, dynamic> toJson() => {
        "order": order,
      };
}
