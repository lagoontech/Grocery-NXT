// To parse this JSON data, do
//
//     final paymentOptionsModel = paymentOptionsModelFromJson(jsonString);

import 'dart:convert';

PaymentOptionsModel paymentOptionsModelFromJson(String str) => PaymentOptionsModel.fromJson(json.decode(str));

String paymentOptionsModelToJson(PaymentOptionsModel data) => json.encode(data.toJson());

class PaymentOptionsModel {
  List<PaymentOption>? paymentOptions;

  PaymentOptionsModel({
    this.paymentOptions,
  });

  factory PaymentOptionsModel.fromJson(Map<String, dynamic> json) => PaymentOptionsModel(
    paymentOptions: json["data"] == null ? [] : List<PaymentOption>.from(json["data"]!.map((x) => PaymentOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": paymentOptions == null ? [] : List<dynamic>.from(paymentOptions!.map((x) => x.toJson())),
  };
}

class PaymentOption {
  String? name;
  String? image;
  int? status;
  int? testMode;
  Credentials? credentials;

  PaymentOption({
    this.name,
    this.image,
    this.status,
    this.testMode,
    this.credentials,
  });

  factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
    name: json["name"],
    image: json["image"],
    status: json["status"],
    testMode: json["test_mode"],
    credentials: json["credentials"] == null ? null : Credentials.fromJson(json["credentials"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "status": status,
    "test_mode": testMode,
    "credentials": credentials?.toJson(),
  };
}

class Credentials {
  String? publicKey;
  String? secretKey;
  String? apiKey;
  String? apiSecret;
  String? name;
  String? description;

  Credentials({
    this.publicKey,
    this.secretKey,
    this.apiKey,
    this.apiSecret,
    this.name,
    this.description,
  });

  factory Credentials.fromJson(Map<String, dynamic> json) => Credentials(
    publicKey: json["public_key"],
    secretKey: json["secret_key"],
    apiKey: json["api_key"],
    apiSecret: json["api_secret"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "public_key": publicKey,
    "secret_key": secretKey,
    "api_key": apiKey,
    "api_secret": apiSecret,
    "name": name,
    "description": description,
  };
}
