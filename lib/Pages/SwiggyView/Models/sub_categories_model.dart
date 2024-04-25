// To parse this JSON data, do
//
//     final subcategoriesModel = subcategoriesModelFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/cupertino.dart';

SubcategoriesModel subcategoriesModelFromJson(String str) => SubcategoriesModel.fromJson(json.decode(str));

String subcategoriesModelToJson(SubcategoriesModel data) => json.encode(data.toJson());

class SubcategoriesModel {
  List<Subcategory>? subcategories;

  SubcategoriesModel({
    this.subcategories,
  });

  factory SubcategoriesModel.fromJson(Map<String, dynamic> json) => SubcategoriesModel(
    subcategories: json["subcategories"] == null ? [] : List<Subcategory>.from(json["subcategories"]!.map((x) => Subcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subcategories": subcategories == null ? [] : List<dynamic>.from(subcategories!.map((x) => x.toJson())),
  };
}

class Subcategory {
  int? id;
  String? name;
  int? imageId;
  int? categoryId;
  String? imageUrl;
  GlobalKey ?positionKey;
  ScrollController ?scrollController;

  Subcategory({
    this.id,
    this.name,
    this.imageId,
    this.categoryId,
    this.imageUrl,
    this.positionKey,
    this.scrollController
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json["id"],
    name: json["name"],
    imageId: json["image_id"],
    categoryId: json["category_id"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_id": imageId,
    "category_id": categoryId,
    "image_url": imageUrl,
  };
}
