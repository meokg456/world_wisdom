class SearchHistory {
  SearchHistory({
    this.id,
    this.content,
  });

  String id;
  String content;

  factory SearchHistory.fromJson(Map<String, dynamic> json) => SearchHistory(
        id: json["id"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
      };
}
