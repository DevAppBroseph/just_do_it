class IsEnough {
  bool? isEnough;

  IsEnough({
    required this.isEnough,
  });

  factory IsEnough.fromJson(Map<String, dynamic> json) {
    return IsEnough(
      isEnough: json['is_enough'],
    );
  }
  Map<String, dynamic> toJson() => {
        "is_enough": isEnough,
      };
}
