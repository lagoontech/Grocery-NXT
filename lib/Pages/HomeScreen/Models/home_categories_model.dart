import 'dart:convert';

HomeCategoriesModel? homeCategoriesModelFromJson(String str) =>
    HomeCategoriesModel.fromJson(json.decode(str));

String homeCategoriesModelToJson(HomeCategoriesModel? data) =>
    json.encode(data!.toJson());

class HomeCategoriesModel {
  HomeCategoriesModel({
    this.categories,
    this.success,
  });

  List<CategoryModel?>? categories;
  bool? success;

  factory HomeCategoriesModel.fromJson(Map<String, dynamic> json) =>
      HomeCategoriesModel(
        categories: json["categories"] == null
            ? []
            : List<CategoryModel?>.from(
            json["categories"]!.map((x) => CategoryModel.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x!.toJson())),
    "success": success,
  };
}

class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
    this.imageUrl,
  });

  dynamic id;
  String? name;
  String? imageUrl;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    name: json["name"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
  };
}
