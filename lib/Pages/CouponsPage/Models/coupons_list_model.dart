// To parse this JSON data, do
//
//     final couponsModel = couponsModelFromJson(jsonString);

import 'dart:convert';

CouponsModel couponsModelFromJson(String str) => CouponsModel.fromJson(json.decode(str));

String couponsModelToJson(CouponsModel data) => json.encode(data.toJson());

class CouponsModel {
  String? type;
  List<Coupon>? coupon;

  CouponsModel({
    this.type,
    this.coupon,
  });

  factory CouponsModel.fromJson(Map<String, dynamic> json) => CouponsModel(
    type: json["type"],
    coupon: json["coupon"] == null ? [] : List<Coupon>.from(json["coupon"]!.map((x) => Coupon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coupon": coupon == null ? [] : List<dynamic>.from(coupon!.map((x) => x.toJson())),
  };
}

class Coupon {
  String? title;
  String? code;
  String? discount;
  String? discountType;
  String? discountOn;
  DateTime? expireDate;
  String? discountOnDetails;

  Coupon({
    this.title,
    this.code,
    this.discount,
    this.discountType,
    this.discountOn,
    this.expireDate,
    this.discountOnDetails,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    title: json["title"],
    code: json["code"],
    discount: json["discount"],
    discountType: json["discount_type"],
    discountOn: json["discount_on"],
    expireDate: json["expire_date"] == null ? null : DateTime.parse(json["expire_date"]),
    discountOnDetails: json["discount_on_details"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "code": code,
    "discount": discount,
    "discount_type": discountType,
    "discount_on": discountOn,
    "expire_date": "${expireDate!.year.toString().padLeft(4, '0')}-${expireDate!.month.toString().padLeft(2, '0')}-${expireDate!.day.toString().padLeft(2, '0')}",
    "discount_on_details": discountOnDetails,
  };
}
