import 'package:world_wisdom/model/rate_model/rating_list.dart';

class Ratings {
  Ratings({
    this.ratingList,
    this.stars,
  });

  List<RatingList> ratingList;
  List<int> stars;

  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
        ratingList: List<RatingList>.from(
            json["ratingList"].map((x) => RatingList.fromJson(x))),
        stars: List<int>.from(json["stars"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ratingList": List<dynamic>.from(ratingList.map((x) => x.toJson())),
        "stars": List<dynamic>.from(stars.map((x) => x)),
      };
}
