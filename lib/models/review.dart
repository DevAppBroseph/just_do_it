class Reviews {
  Reviews({
    required this.reviewsDetail,
    this.ranking,
  });

  List<ReviewsDetail> reviewsDetail;
  double? ranking;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        reviewsDetail: List<ReviewsDetail>.from(
            json["reviews_detail"].map((x) => ReviewsDetail.fromJson(x))),
        ranking: json["ranking"],
      );

  Map<String, dynamic> toJson() => {
        "reviews_detail":
            List<dynamic>.from(reviewsDetail.map((x) => x.toJson())),
        "ranking": ranking,
      };
  bool needsToGetUpdated(Reviews reviews) {
    return reviews.ranking != ranking ||
            reviews.reviewsDetail.length != reviewsDetail.length
        ? true
        : false;
  }
}

class ReviewerDetails {
  ReviewerDetails({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
  });

  int id;
  String firstname;
  String lastname;
  String? photo;

  factory ReviewerDetails.fromJson(Map<String, dynamic> json) =>
      ReviewerDetails(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "photo": photo,
      };
}

class ReviewsDetail {
  ReviewsDetail({
    required this.id,
    required this.reviewerDetails,
    required this.message,
    required this.mark,
  });

  int id;
  ReviewerDetails reviewerDetails;
  String message;
  int mark;

  factory ReviewsDetail.fromJson(Map<String, dynamic> json) => ReviewsDetail(
        id: json["id"],
        reviewerDetails: ReviewerDetails.fromJson(json["reviewer_details"]),
        message: json["message"],
        mark: json["mark"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reviewer_details": reviewerDetails.toJson(),
        "message": message,
        "mark": mark,
      };
}
