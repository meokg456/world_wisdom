class SearchForm {
  SearchForm({
    this.keyword,
    this.opt,
    this.limit,
    this.offset,
  });

  SearchForm.empty();

  String keyword = "";
  Options opt = Options.empty();
  int limit = 4;
  int offset = 1;

  factory SearchForm.fromJson(Map<String, dynamic> json) => SearchForm(
        keyword: json["keyword"],
        opt: Options.fromJson(json["opt"]),
        limit: json["limit"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "keyword": keyword,
        "opt": opt.toJson(),
        "limit": limit,
        "offset": offset,
      };
}

class Options {
  Options({
    this.sortCriteria,
    this.category,
    this.time,
    this.price,
  });

  Options.empty();

  SortCriteria sortCriteria = SortCriteria.priceASC();
  List<String> category = [];
  List<Range> time = [];
  List<Range> price = [];

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        sortCriteria: SortCriteria.fromJson(json["sort"]),
        category: List<String>.from(json["category"].map((x) => x)),
        time: List<Range>.from(json["time"].map((x) => Range.fromJson(x))),
        price: List<Range>.from(json["price"].map((x) => Range.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sort": sortCriteria.toJson(),
        "category": List<dynamic>.from(category.map((x) => x)),
        "time": List<dynamic>.from(time.map((x) => x.toJson())),
        "price": List<dynamic>.from(price.map((x) => x.toJson())),
      };
}

class Range {
  Range({
    this.min,
    this.max,
  });

  int min;
  int max;

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        min: json["min"],
        max: json["max"],
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
      };
}

class SortCriteria {
  SortCriteria({
    this.attribute,
    this.rule,
  });

  SortCriteria.priceASC();

  String attribute = "price";
  String rule = "ASC";

  factory SortCriteria.fromJson(Map<String, dynamic> json) => SortCriteria(
        attribute: json["attribute"],
        rule: json["rule"],
      );

  Map<String, dynamic> toJson() => {
        "attribute": attribute,
        "rule": rule,
      };
}
