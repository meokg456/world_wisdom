import 'package:world_wisdom/model/search_model/search_form.dart';

class SearchV2Form {
  SearchV2Form({
    this.token,
    this.keyword,
    this.limit,
    this.offset,
    this.options,
  });
  SearchV2Form.empty();

  String token;
  String keyword;
  int limit = 10;
  int offset = 0;
  Options options = Options.empty();

  factory SearchV2Form.fromJson(Map<String, dynamic> json) => SearchV2Form(
        token: json["token"],
        keyword: json["keyword"],
        limit: json["limit"],
        offset: json["offset"],
        options: Options.fromJson(json["opt"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "keyword": keyword,
        "limit": limit,
        "offset": offset,
        "opt": options.toJson(),
      };
}
