import 'dart:convert';

StateModel? stateModelFromJson(String str) =>
    StateModel.fromJson(json.decode(str));

String stateModelToJson(StateModel? data) => json.encode(data!.toJson());

class StateModel {
  StateModel({
    this.states,
    this.nextPage,
  });

  List<CountryState?>? states;
  String? nextPage;

  factory StateModel.fromJson(Map json) => StateModel(
    states: json["state"] == null
        ? []
        : json["state"]["data"] == null
        ? []
        : List<CountryState?>.from(
        json["state"]["data"]!.map((x) => CountryState.fromJson(x))),
    nextPage: json["next_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "state": states == null
        ? []
        : List<dynamic>.from(states!.map((x) => x!.toJson())),
  };
}

class CountryState {
  CountryState({
    this.id,
    this.name,
    this.countryId,
  });

  dynamic id;
  String? name;
  dynamic countryId;

  factory CountryState.fromJson(Map<String, dynamic> json) => CountryState(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_id": countryId,
  };
}
