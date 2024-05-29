// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

OrderListModel orderListModelFromJson(String str) => OrderListModel.fromJson(json.decode(str));

String orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  Order? order;
  Suborders? suborders;

  OrderListModel({
    this.order,
    this.suborders,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
    order: json["order"] == null ? null : Order.fromJson(json["order"]),
    suborders: json["suborders"] == null ? null : Suborders.fromJson(json["suborders"]),
  );

  Map<String, dynamic> toJson() => {
    "order": order?.toJson(),
    "suborders": suborders?.toJson(),
  };
}

class Order {
  int? currentPage;
  List<OrderElement>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Order({
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

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<OrderElement>.from(json["data"]!.map((x) => OrderElement.fromJson(x))),
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

class OrderElement {
  int? id;
  String? coupon;
  String? couponAmount;
  String? paymentTrack;
  PaymentGateway? paymentGateway;
  String? transactionId;
  OrderOrderStatus? orderStatus;
  OrderOrderStatus? paymentStatus;
  int? invoiceNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  DatumType? type;
  dynamic note;
  dynamic selectedCustomer;
  PaymentMeta? paymentMeta;
  List<OrderTrack>? orderTrack;

  OrderElement({
    this.id,
    this.coupon,
    this.couponAmount,
    this.paymentTrack,
    this.paymentGateway,
    this.transactionId,
    this.orderStatus,
    this.paymentStatus,
    this.invoiceNumber,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.type,
    this.note,
    this.selectedCustomer,
    this.paymentMeta,
    this.orderTrack,
  });

  factory OrderElement.fromJson(Map<String, dynamic> json) => OrderElement(
    id: json["id"],
    coupon: json["coupon"],
    couponAmount: json["coupon_amount"],
    paymentTrack: json["payment_track"],
    paymentGateway: paymentGatewayValues.map[json["payment_gateway"]]!,
    transactionId: json["transaction_id"],
    orderStatus: orderOrderStatusValues.map[json["order_status"]]!,
    paymentStatus: orderOrderStatusValues.map[json["payment_status"]]!,
    invoiceNumber: json["invoice_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
    type: datumTypeValues.map[json["type"]]!,
    note: json["note"],
    selectedCustomer: json["selected_customer"],
    paymentMeta: json["payment_meta"] == null ? null : PaymentMeta.fromJson(json["payment_meta"]),
    orderTrack: json["order_track"] == null ? [] : List<OrderTrack>.from(json["order_track"]!.map((x) => OrderTrack.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "coupon": coupon,
    "coupon_amount": couponAmount,
    "payment_track": paymentTrack,
    "payment_gateway": paymentGatewayValues.reverse[paymentGateway],
    "transaction_id": transactionId,
    "order_status": orderOrderStatusValues.reverse[orderStatus],
    "payment_status": orderOrderStatusValues.reverse[paymentStatus],
    "invoice_number": invoiceNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user_id": userId,
    "type": datumTypeValues.reverse[type],
    "note": note,
    "selected_customer": selectedCustomer,
    "payment_meta": paymentMeta?.toJson(),
    "order_track": orderTrack == null ? [] : List<dynamic>.from(orderTrack!.map((x) => x.toJson())),
  };
}

enum OrderOrderStatus {
  COMPLETE
}

final orderOrderStatusValues = EnumValues({
  "complete": OrderOrderStatus.COMPLETE
});

class OrderTrack {
  int? id;
  int? orderId;
  OrderTrackName? name;
  int? updatedBy;
  Table? table;
  DateTime? createdAt;

  OrderTrack({
    this.id,
    this.orderId,
    this.name,
    this.updatedBy,
    this.table,
    this.createdAt,
  });

  factory OrderTrack.fromJson(Map<String, dynamic> json) => OrderTrack(
    id: json["id"],
    orderId: json["order_id"],
    name: orderTrackNameValues.map[json["name"]]!,
    updatedBy: json["updated_by"],
    table: tableValues.map[json["table"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "name": orderTrackNameValues.reverse[name],
    "updated_by": updatedBy,
    "table": tableValues.reverse[table],
    "created_at": createdAt?.toIso8601String(),
  };
}

enum OrderTrackName {
  ORDERED,
  PICKED_BY_COURIER
}

final orderTrackNameValues = EnumValues({
  "ordered": OrderTrackName.ORDERED,
  "picked_by_courier": OrderTrackName.PICKED_BY_COURIER
});

enum Table {
  ADMIN,
  USERS
}

final tableValues = EnumValues({
  "admin": Table.ADMIN,
  "users": Table.USERS
});

enum PaymentGateway {
  RAZORPAY
}

final paymentGatewayValues = EnumValues({
  "razorpay": PaymentGateway.RAZORPAY
});

class PaymentMeta {
  int? id;
  int? orderId;
  String? subTotal;
  String? couponAmount;
  String? shippingCost;
  String? taxAmount;
  String? totalAmount;
  dynamic paymentAttachments;

  PaymentMeta({
    this.id,
    this.orderId,
    this.subTotal,
    this.couponAmount,
    this.shippingCost,
    this.taxAmount,
    this.totalAmount,
    this.paymentAttachments,
  });

  factory PaymentMeta.fromJson(Map<String, dynamic> json) => PaymentMeta(
    id: json["id"],
    orderId: json["order_id"],
    subTotal: json["sub_total"],
    couponAmount: json["coupon_amount"],
    shippingCost: json["shipping_cost"],
    taxAmount: json["tax_amount"],
    totalAmount: json["total_amount"],
    paymentAttachments: json["payment_attachments"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "sub_total": subTotal,
    "coupon_amount": couponAmount,
    "shipping_cost": shippingCost,
    "tax_amount": taxAmount,
    "total_amount": totalAmount,
    "payment_attachments": paymentAttachments,
  };
}

enum DatumType {
  API
}

final datumTypeValues = EnumValues({
  "api": DatumType.API
});

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

class Suborders {
  int? currentPage;
  List<SubordersDatum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Suborders({
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

  factory Suborders.fromJson(Map<String, dynamic> json) => Suborders(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<SubordersDatum>.from(json["data"]!.map((x) => SubordersDatum.fromJson(x))),
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

class SubordersDatum {
  int? id;
  int? orderId;
  dynamic vendorId;
  String? totalAmount;
  String? shippingCost;
  String? taxAmount;
  TaxType? taxType;
  int? orderAddressId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? orderNumber;
  PurpleStatus? paymentStatus;
  PurpleStatus? orderStatus;
  OrderElement? order;
  List<OrderItem>? orderItem;

  SubordersDatum({
    this.id,
    this.orderId,
    this.vendorId,
    this.totalAmount,
    this.shippingCost,
    this.taxAmount,
    this.taxType,
    this.orderAddressId,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.paymentStatus,
    this.orderStatus,
    this.order,
    this.orderItem,
  });

  factory SubordersDatum.fromJson(Map<String, dynamic> json) => SubordersDatum(
    id: json["id"],
    orderId: json["order_id"],
    vendorId: json["vendor_id"],
    totalAmount: json["total_amount"],
    shippingCost: json["shipping_cost"],
    taxAmount: json["tax_amount"],
    taxType: taxTypeValues.map[json["tax_type"]]!,
    orderAddressId: json["order_address_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    orderNumber: json["order_number"],
    paymentStatus: purpleStatusValues.map[json["payment_status"]]!,
    orderStatus: purpleStatusValues.map[json["order_status"]]!,
    order: json["order"] == null ? null : OrderElement.fromJson(json["order"]),
    orderItem: json["order_item"] == null ? [] : List<OrderItem>.from(json["order_item"]!.map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "vendor_id": vendorId,
    "total_amount": totalAmount,
    "shipping_cost": shippingCost,
    "tax_amount": taxAmount,
    "tax_type": taxTypeValues.reverse[taxType],
    "order_address_id": orderAddressId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "order_number": orderNumber,
    "payment_status": purpleStatusValues.reverse[paymentStatus],
    "order_status": purpleStatusValues.reverse[orderStatus],
    "order": order?.toJson(),
    "order_item": orderItem == null ? [] : List<dynamic>.from(orderItem!.map((x) => x.toJson())),
  };
}

class OrderItem {
  int? id;
  int? subOrderId;
  int? orderId;
  int? productId;
  int? variantId;
  int? quantity;
  String? price;
  String? salePrice;
  String? taxAmount;
  TaxType? taxType;
  Product? product;

  OrderItem({
    this.id,
    this.subOrderId,
    this.orderId,
    this.productId,
    this.variantId,
    this.quantity,
    this.price,
    this.salePrice,
    this.taxAmount,
    this.taxType,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    subOrderId: json["sub_order_id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    variantId: json["variant_id"],
    quantity: json["quantity"],
    price: json["price"],
    salePrice: json["sale_price"],
    taxAmount: json["tax_amount"],
    taxType: taxTypeValues.map[json["tax_type"]]!,
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sub_order_id": subOrderId,
    "order_id": orderId,
    "product_id": productId,
    "variant_id": variantId,
    "quantity": quantity,
    "price": price,
    "sale_price": salePrice,
    "tax_amount": taxAmount,
    "tax_type": taxTypeValues.reverse[taxType],
    "product": product?.toJson(),
  };
}

class Product {
  int? id;
  String? name;
  String? slug;
  String? summary;
  String? description;
  String? imageId;
  int? price;
  int? salePrice;
  int? cost;
  int? badgeId;
  int? brandId;
  int? statusId;
  int? productType;
  dynamic soldCount;
  int? minPurchase;
  int? maxPurchase;
  int? isRefundable;
  int? isInHouse;
  int? isInventoryWarnAble;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? adminId;
  dynamic vendorId;
  int? isTaxable;
  dynamic taxClassId;
  Image? image;
  Badge? badge;
  Uom? uom;

  Product({
    this.id,
    this.name,
    this.slug,
    this.summary,
    this.description,
    this.imageId,
    this.price,
    this.salePrice,
    this.cost,
    this.badgeId,
    this.brandId,
    this.statusId,
    this.productType,
    this.soldCount,
    this.minPurchase,
    this.maxPurchase,
    this.isRefundable,
    this.isInHouse,
    this.isInventoryWarnAble,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.adminId,
    this.vendorId,
    this.isTaxable,
    this.taxClassId,
    this.image,
    this.badge,
    this.uom,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    summary: json["summary"],
    description: json["description"],
    imageId: json["image_id"],
    price: json["price"],
    salePrice: json["sale_price"],
    cost: json["cost"],
    badgeId: json["badge_id"],
    brandId: json["brand_id"],
    statusId: json["status_id"],
    productType: json["product_type"],
    soldCount: json["sold_count"],
    minPurchase: json["min_purchase"],
    maxPurchase: json["max_purchase"],
    isRefundable: json["is_refundable"],
    isInHouse: json["is_in_house"],
    isInventoryWarnAble: json["is_inventory_warn_able"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    adminId: json["admin_id"],
    vendorId: json["vendor_id"],
    isTaxable: json["is_taxable"],
    taxClassId: json["tax_class_id"],
    image: json["image"] == null ? null : Image.fromJson(json["image"]),
    badge: json["badge"] == null ? null : Badge.fromJson(json["badge"]),
    uom: json["uom"] == null ? null : Uom.fromJson(json["uom"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "summary": summary,
    "description": description,
    "image_id": imageId,
    "price": price,
    "sale_price": salePrice,
    "cost": cost,
    "badge_id": badgeId,
    "brand_id": brandId,
    "status_id": statusId,
    "product_type": productType,
    "sold_count": soldCount,
    "min_purchase": minPurchase,
    "max_purchase": maxPurchase,
    "is_refundable": isRefundable,
    "is_in_house": isInHouse,
    "is_inventory_warn_able": isInventoryWarnAble,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "admin_id": adminId,
    "vendor_id": vendorId,
    "is_taxable": isTaxable,
    "tax_class_id": taxClassId,
    "image": image?.toJson(),
    "badge": badge?.toJson(),
    "uom": uom?.toJson(),
  };
}

class Badge {
  int? id;
  BadgeName? name;
  int? image;
  For? badgeFor;
  int? saleCount;
  BadgeType? type;
  Status? status;
  dynamic createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Image? badgeImage;

  Badge({
    this.id,
    this.name,
    this.image,
    this.badgeFor,
    this.saleCount,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.badgeImage,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json["id"],
    name: badgeNameValues.map[json["name"]]!,
    image: json["image"],
    badgeFor: forValues.map[json["for"]]!,
    saleCount: json["sale_count"],
    type: badgeTypeValues.map[json["type"]]!,
    status: statusValues.map[json["status"]]!,
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    badgeImage: json["badge_image"] == null ? null : Image.fromJson(json["badge_image"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": badgeNameValues.reverse[name],
    "image": image,
    "for": forValues.reverse[badgeFor],
    "sale_count": saleCount,
    "type": badgeTypeValues.reverse[type],
    "status": statusValues.reverse[status],
    "created_at": createdAt,
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "badge_image": badgeImage?.toJson(),
  };
}

enum For {
  PRODUCTS
}

final forValues = EnumValues({
  "products": For.PRODUCTS
});

class Image {
  int? id;
  String? title;
  String? path;
  dynamic alt;
  String? size;
  String? dimensions;
  dynamic userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic vendorId;

  Image({
    this.id,
    this.title,
    this.path,
    this.alt,
    this.size,
    this.dimensions,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json["id"],
    title: json["title"],
    path: json["path"],
    alt: json["alt"],
    size: json["size"],
    dimensions: json["dimensions"],
    userId: json["user_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    vendorId: json["vendor_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "path": path,
    "alt": alt,
    "size": size,
    "dimensions": dimensions,
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "vendor_id": vendorId,
  };
}

enum BadgeName {
  BEST_SELLER,
  NEW_ARRIVAL,
  TOP_RATED
}

final badgeNameValues = EnumValues({
  "Best Seller": BadgeName.BEST_SELLER,
  "New Arrival": BadgeName.NEW_ARRIVAL,
  "Top Rated": BadgeName.TOP_RATED
});

enum Status {
  ACTIVE
}

final statusValues = EnumValues({
  "active": Status.ACTIVE
});

enum BadgeType {
  ARRIVAL,
  RATING,
  SALES
}

final badgeTypeValues = EnumValues({
  "arrival": BadgeType.ARRIVAL,
  "rating": BadgeType.RATING,
  "sales": BadgeType.SALES
});

class Uom {
  int? id;
  int? productId;
  int? unitId;
  int? quantity;
  Unit? unit;

  Uom({
    this.id,
    this.productId,
    this.unitId,
    this.quantity,
    this.unit,
  });

  factory Uom.fromJson(Map<String, dynamic> json) => Uom(
    id: json["id"],
    productId: json["product_id"],
    unitId: json["unit_id"],
    quantity: json["quantity"],
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "unit_id": unitId,
    "quantity": quantity,
    "unit": unit?.toJson(),
  };
}

class Unit {
  int? id;
  UnitName? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Unit({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    name: unitNameValues.map[json["name"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": unitNameValues.reverse[name],
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

enum UnitName {
  GRAM_GM,
  KG,
  LITTER_LT,
  PIECE
}

final unitNameValues = EnumValues({
  "Gram (GM)": UnitName.GRAM_GM,
  "KG": UnitName.KG,
  "Litter (LT)": UnitName.LITTER_LT,
  "Piece": UnitName.PIECE
});

enum TaxType {
  INCLUSIVE_PRICE
}

final taxTypeValues = EnumValues({
  "inclusive_price": TaxType.INCLUSIVE_PRICE
});

enum PurpleStatus {
  PENDING
}

final purpleStatusValues = EnumValues({
  "pending": PurpleStatus.PENDING
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
