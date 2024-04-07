// To parse this JSON data, do
//
//     final productsList = productsListFromJson(jsonString);

import 'dart:convert';

import 'package:grocery_nxt/Pages/ProductDetailsView/Model/product_details_model.dart';

ProductsList productsListFromJson(String str) => ProductsList.fromJson(json.decode(str));

String productsListToJson(ProductsList data) => json.encode(data.toJson());

class ProductsList {
  List<Product>? products;
  Links? links;
  Meta? meta;

  ProductsList({
    this.products,
    this.links,
    this.meta,
  });

  factory ProductsList.fromJson(Map<String, dynamic> json) => ProductsList(
    products: json["data"] == null ? [] : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class Product {
  int? prdId;
  String? title;
  String? imgUrl;
  int? campaignPercentage;
  int? price;
  int? discountPrice;
  Badge? badge;
  bool? campaignProduct;
  int? campaignStock;
  int? stockCount;
  dynamic avgRatting;
  bool? isCartAble;
  dynamic vendorId;
  dynamic vendorName;
  int? categoryId;
  int? subCategoryId;
  List<dynamic>? childCategoryIds;
  String? url;
  String? randomKey;
  String? randomSecret;
  int cartQuantity;
  AdditionalInfoStore ?variantInfo;
  ProductColor ?productColor;

  Product({
    this.prdId,
    this.title,
    this.imgUrl,
    this.campaignPercentage,
    this.price,
    this.discountPrice,
    this.badge,
    this.campaignProduct,
    this.campaignStock,
    this.stockCount,
    this.avgRatting,
    this.isCartAble,
    this.vendorId,
    this.vendorName,
    this.categoryId,
    this.subCategoryId,
    this.childCategoryIds,
    this.url,
    this.randomKey,
    this.randomSecret,
    this.cartQuantity=0,
    this.variantInfo,
    this.productColor
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    prdId: json["prd_id"],
    title: json["title"],
    imgUrl: json["img_url"],
    campaignPercentage: json["campaign_percentage"],
    price: json["price"],
    discountPrice: json["discount_price"],
    badge: json["badge"] == null ? null : Badge.fromJson(json["badge"]),
    campaignProduct: json["campaign_product"],
    campaignStock: json["campaign_stock"],
    stockCount: json["stock_count"],
    avgRatting: json["avg_ratting"],
    isCartAble: json["is_cart_able"],
    vendorId: json["vendor_id"],
    vendorName: json["vendor_name"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    childCategoryIds: json["child_category_ids"] == null ? [] : List<dynamic>.from(json["child_category_ids"]!.map((x) => x)),
    url: json["url"],
    randomKey: json["random_key"],
    randomSecret: json["random_secret"],
    cartQuantity: json["cart_qty"] ?? 0,
    variantInfo: json["variant_info"] == null ? null : AdditionalInfoStore.fromJson(json["variant_info"]),
    productColor: json["product_size"] == null ? null : ProductColor.fromJson(json["product_size"])
  );

  Map<String, dynamic> toJson() => {
    "prd_id": prdId,
    "title": title,
    "cart_qty": cartQuantity,
    "qty": cartQuantity,
    "img_url": imgUrl,
    "campaign_percentage": campaignPercentage,
    "variant_info": variantInfo?.toJson(),
    "product_size": productColor?.toJson(),
    "discount_price": discountPrice,
    "badge": badge?.toJson(),
    "campaign_product": campaignProduct,
    "campaign_stock": campaignStock,
    "stock_count": stockCount,
    "avg_ratting": avgRatting,
    "is_cart_able": isCartAble,
    "vendor_id": vendorId,
    "vendor_name": vendorName,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "child_category_ids": childCategoryIds == null ? [] : List<dynamic>.from(childCategoryIds!.map((x) => x)),
    "url": url,
    "random_key": randomKey,
    "random_secret": randomSecret,
    'hash': '',
    'id': prdId,
    "price": discountPrice,
    "original_price": price,
    "options": {
      "pid_id": variantInfo==null?"":variantInfo!.pidId,
      "tax_options_sum_rate": /*randomKey.toString().length > 23
          ? randomKey.toString().substring(8, 10)
          : "0",*/"0",
      "price": /*randomSecret.toString().length > 23
          ? randomSecret.toString().substring(15, 17)
          : "0"*/"0",
      "variant_id": productColor==null?"":productColor!.id!,
      "attributes": {},
      "used_categories": categoryId,
      "vendor_id": vendorId ?? 'admin',
    },
    "stock": stockCount,
    "subtotal": cartQuantity * discountPrice!
  };
}

class Badge {
  String? badgeName;
  dynamic image;

  Badge({
    this.badgeName,
    this.image,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    badgeName: json["badge_name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "badge_name": badgeName,
    "image": image,
  };
}

class Links {
  String? first;
  String? last;
  dynamic prev;
  String? next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
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
