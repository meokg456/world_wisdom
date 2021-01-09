// To parse this JSON data, do
//
//     final searchHistoryModel = searchHistoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:world_wisdom/model/search_v2_model/search_history.dart';

SearchHistoryModel searchHistoryModelFromJson(String str) =>
    SearchHistoryModel.fromJson(json.decode(str));

String searchHistoryModelToJson(SearchHistoryModel data) =>
    json.encode(data.toJson());

class SearchHistoryModel {
  SearchHistoryModel({
    this.message,
    this.payload,
  });

  String message;
  Payload payload;

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) =>
      SearchHistoryModel(
        message: json["message"],
        payload: Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "payload": payload.toJson(),
      };
}

class Payload {
  Payload({
    this.searchHistory,
  });

  List<SearchHistory> searchHistory = [];

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        searchHistory: List<SearchHistory>.from(
            json["data"].map((x) => SearchHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(searchHistory.map((x) => x.toJson())),
      };
}
