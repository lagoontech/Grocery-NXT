// To parse this JSON data, do
//
//     final profileInfoModel = profileInfoModelFromJson(jsonString);

import 'dart:convert';

ProfileInfoModel profileInfoModelFromJson(String str) => ProfileInfoModel.fromJson(json.decode(str));

String profileInfoModelToJson(ProfileInfoModel data) => json.encode(data.toJson());

class ProfileInfoModel {
  UserDetails? userDetails;

  ProfileInfoModel({
    this.userDetails,
  });

  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) => ProfileInfoModel(
    userDetails: json["user_details"] == null ? null : UserDetails.fromJson(json["user_details"]),
  );

  Map<String, dynamic> toJson() => {
    "user_details": userDetails?.toJson(),
  };
}

class UserDetails {
  int? id;
  String? name;
  String? email;
  String? username;
  String? emailVerified;
  dynamic emailVerifyToken;
  String? phone;
  String? address;
  dynamic state;
  dynamic city;
  dynamic zipcode;
  String? country;
  dynamic image;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic facebookId;
  dynamic googleId;
  dynamic deletedAt;
  dynamic checkOnlineStatus;
  dynamic firebaseDeviceToken;
  int? usertype;
  dynamic gstnumber;
  int? otp;
  dynamic companyname;
  dynamic fssa;
  dynamic profileImageUrl;
  dynamic profileImage;
  UserCountry? userCountry;
  List<dynamic>? shipping;
  dynamic userState;
  dynamic userCity;

  UserDetails({
    this.id,
    this.name,
    this.email,
    this.username,
    this.emailVerified,
    this.emailVerifyToken,
    this.phone,
    this.address,
    this.state,
    this.city,
    this.zipcode,
    this.country,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.facebookId,
    this.googleId,
    this.deletedAt,
    this.checkOnlineStatus,
    this.firebaseDeviceToken,
    this.usertype,
    this.gstnumber,
    this.otp,
    this.companyname,
    this.fssa,
    this.profileImageUrl,
    this.profileImage,
    this.userCountry,
    this.shipping,
    this.userState,
    this.userCity,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    username: json["username"],
    emailVerified: json["email_verified"],
    emailVerifyToken: json["email_verify_token"],
    phone: json["phone"],
    address: json["address"],
    state: json["state"],
    city: json["city"],
    zipcode: json["zipcode"],
    country: json["country"],
    image: json["image"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    facebookId: json["facebook_id"],
    googleId: json["google_id"],
    deletedAt: json["deleted_at"],
    checkOnlineStatus: json["check_online_status"],
    firebaseDeviceToken: json["firebase_device_token"],
    usertype: json["usertype"],
    gstnumber: json["gstnumber"],
    otp: json["otp"],
    companyname: json["companyname"],
    fssa: json["fssa"],
    profileImageUrl: json["profile_image_url"],
    profileImage: json["profile_image"],
    userCountry: json["user_country"] == null ? null : UserCountry.fromJson(json["user_country"]),
    shipping: json["shipping"] == null ? [] : List<dynamic>.from(json["shipping"]!.map((x) => x)),
    userState: json["user_state"],
    userCity: json["user_city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "username": username,
    "email_verified": emailVerified,
    "email_verify_token": emailVerifyToken,
    "phone": phone,
    "address": address,
    "state": state,
    "city": city,
    "zipcode": zipcode,
    "country": country,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "facebook_id": facebookId,
    "google_id": googleId,
    "deleted_at": deletedAt,
    "check_online_status": checkOnlineStatus,
    "firebase_device_token": firebaseDeviceToken,
    "usertype": usertype,
    "gstnumber": gstnumber,
    "otp": otp,
    "companyname": companyname,
    "fssa": fssa,
    "profile_image_url": profileImageUrl,
    "profile_image": profileImage,
    "user_country": userCountry?.toJson(),
    "shipping": shipping == null ? [] : List<dynamic>.from(shipping!.map((x) => x)),
    "user_state": userState,
    "user_city": userCity,
  };
}

class UserCountry {
  int? id;
  String? name;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserCountry({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UserCountry.fromJson(Map<String, dynamic> json) => UserCountry(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
