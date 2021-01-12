import 'package:world_wisdom/model/rate_model/rating.dart';

class RateModel {
  RateModel({
    this.ratingList,
    this.stars,
  });

  List<Rating> ratingList;
  List<int> stars;

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
        ratingList: List<Rating>.from(
            json["ratingList"].map((x) => Rating.fromJson(x))),
        stars: List<int>.from(json["stars"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ratingList": List<dynamic>.from(ratingList.map((x) => x.toJson())),
        "stars": List<dynamic>.from(stars.map((x) => x)),
      };
}
