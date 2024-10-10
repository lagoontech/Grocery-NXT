import 'dart:convert';

ShippingAddressListModel shippingAddressListModelFromJson(String str) =>
    ShippingAddressListModel.fromJson(json.decode(str));

class ShippingAddressListModel {
  ShippingAddressListModel({
    required this.data,
  });

  List<ShippingAddress> data;

  factory ShippingAddressListModel.fromJson(Map<String, dynamic> json) =>
      ShippingAddressListModel(
        data: List<ShippingAddress>.from(json["data"].map((x) => ShippingAddress.fromJson(x))),
      );
}

class ShippingAddress {
  ShippingAddress({
    this.id,
    this.name = "",
    this.email = "",
    this.phone = "",
     this.userId,
     this.countryId,
     this.stateId,
    this.city,
     this.zipCode,
    this.address,
     this.shippingAddressName,
     this.getStates,
    this.country,
    this.state,
    this.deletingAddress = false,
  });

  dynamic id;
  String name;
  String email;
  String phone;
  dynamic userId;
  dynamic countryId;
  dynamic stateId;
  Country? city;
  String? zipCode;
  String? address;
  String? shippingAddressName;
  List<GetState> ?getStates;
  Country? country;
  Country? state;
  bool ?deletingAddress;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    id: json["id"],
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
    userId: json["user_id"],
    countryId: json["country_id"],
    stateId: json["state_id"],
    city: json["cities"] == null ? null : Country.fromJson(json["cities"]),
    zipCode: json["zip_code"],
    address: json["address"],
    shippingAddressName: json["shipping_address_name"],
    getStates: json["get_states"] == null
        ? []
        : List<GetState>.from(
        json["get_states"].map((x) => GetState.fromJson(x))),
    country:
    json["country"] == null ? null : Country.fromJson(json["country"]),
    state: json["state"] == null ? null : Country.fromJson(json["state"]),
  );
}

class Country {
  Country({
    required this.id,
    required this.name,
  });

  dynamic id;
  String name;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class GetState {
  GetState({
    required this.id,
    required this.name,
    required this.countryId,
    required this.status,
  });

  dynamic id;
  String? name;
  dynamic countryId;
  dynamic status;

  factory GetState.fromJson(Map<String, dynamic> json) => GetState(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
    status: json["status"]!,
  );
}
