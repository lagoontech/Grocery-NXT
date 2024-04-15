// To parse this JSON data, do
//
//     final carouselModel = carouselModelFromJson(jsonString);

import 'dart:convert';

CarouselModel carouselModelFromJson(String str) => CarouselModel.fromJson(json.decode(str));

String carouselModelToJson(CarouselModel data) => json.encode(data.toJson());

class CarouselModel {
  int? currentPage;
  List<Carousel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  CarouselModel({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) => CarouselModel(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<Carousel>.from(json["data"]!.map((x) => Carousel.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Carousel {
  String? title;
  String? description;
  String? image;
  String? buttonUrl;
  String? buttonText;
  dynamic campaign;
  dynamic category;

  Carousel({
    this.title,
    this.description,
    this.image,
    this.buttonUrl,
    this.buttonText,
    this.campaign,
    this.category,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) => Carousel(
    title: json["title"],
    description: json["description"],
    image: json["image"],
    buttonUrl: json["button_url"],
    buttonText: json["button_text"],
    campaign: json["campaign"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "image": image,
    "button_url": buttonUrl,
    "button_text": buttonText,
    "campaign": campaign,
    "category": category,
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
