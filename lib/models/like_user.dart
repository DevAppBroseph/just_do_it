class FavouritesUser {
  int? user;
  bool? asCustomer;

  FavouritesUser({
    required this.user,
    required this.asCustomer,
  });

  factory FavouritesUser.fromJson(Map<String, dynamic> json) {
    return FavouritesUser(
      user: json['user'],
      asCustomer: json['as_customer'],
    );
  }
  Map<String, dynamic> toJson() => {
        "user": user,
        'as_customer': asCustomer,
      };
}
