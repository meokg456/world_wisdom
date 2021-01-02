import 'package:world_wisdom/model/category_model/category.dart';

class CategoryModel {
  CategoryModel({
    this.message,
    this.categories,
  });

  String message;
  List<Category> categories;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        message: json["message"],
        categories: List<Category>.from(json["payload"]
            .map((categoryJson) => Category.fromJson(categoryJson))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload":
            List<dynamic>.from(categories.map((category) => category.toJson())),
      };
}
