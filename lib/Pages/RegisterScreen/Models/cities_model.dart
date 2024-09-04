// To parse this JSON data, do
//
//     final citiesModel = citiesModelFromJson(jsonString);

import 'dart:convert';

CitiesModel citiesModelFromJson(String str) => CitiesModel.fromJson(json.decode(str));

String citiesModelToJson(CitiesModel data) => json.encode(data.toJson());

class CitiesModel {
  List<City>? cities;

  CitiesModel({
    this.cities,
  });

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
    cities: json["cities"] == null ? [] : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cities": cities == null ? [] : List<dynamic>.from(cities!.map((x) => x.toJson())),
  };
}

class City {
  int? id;
  String? name;
  int? stateId;

  City({
    this.id,
    this.name,
    this.stateId,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    stateId: json["state_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state_id": stateId,
  };
}
