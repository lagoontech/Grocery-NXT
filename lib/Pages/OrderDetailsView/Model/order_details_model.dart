// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  List<Order>? order;
  PaymentDetails? paymentDetails;
  OrderTrack? orderTrack;
  String ?secretKey;

  OrderDetailsModel({
    this.order,
    this.paymentDetails,
    this.orderTrack,
    this.secretKey
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    order: json["order"] == null ? [] : List<Order>.from(json["order"]!.map((x) => Order.fromJson(x))),
    paymentDetails: json["payment_details"] == null ? null : PaymentDetails.fromJson(json["payment_details"]),
    orderTrack: json["order_track"] == null ? null : OrderTrack.fromJson(json["order_track"]),
    secretKey: json["secret_key"],
  );

  Map<String, dynamic> toJson() => {
    "order": order == null ? [] : List<dynamic>.from(order!.map((x) => x.toJson())),
    "payment_details": paymentDetails?.toJson(),
    "order_track": orderTrack?.toJson(),
  };
}

class Order {
  int? id;
  int? orderId;
  dynamic vendorId;
  String? totalAmount;
  String? shippingCost;
  String? taxAmount;
  String? taxType;
  int? orderAddressId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? orderNumber;
  String? paymentStatus;
  String? orderStatus;
  PaymentDetails? order;
  dynamic vendor;
  List<OrderItem>? orderItem;

  Order({
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
    this.vendor,
    this.orderItem,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    orderId: json["order_id"],
    vendorId: json["vendor_id"],
    totalAmount: json["total_amount"],
    shippingCost: json["shipping_cost"],
    taxAmount: json["tax_amount"],
    taxType: json["tax_type"],
    orderAddressId: json["order_address_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    orderNumber: json["order_number"],
    paymentStatus: json["payment_status"],
    orderStatus: json["order_status"],
    order: json["order"] == null ? null : PaymentDetails.fromJson(json["order"]),
    vendor: json["vendor"],
    orderItem: json["order_item"] == null ? [] : List<OrderItem>.from(json["order_item"]!.map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "vendor_id": vendorId,
    "total_amount": totalAmount,
    "shipping_cost": shippingCost,
    "tax_amount": taxAmount,
    "tax_type": taxType,
    "order_address_id": orderAddressId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "order_number": orderNumber,
    "payment_status": paymentStatus,
    "order_status": orderStatus,
    "order": order?.toJson(),
    "vendor": vendor,
    "order_item": orderItem == null ? [] : List<dynamic>.from(orderItem!.map((x) => x.toJson())),
  };
}

class PaymentDetails {
  int? id;
  String? coupon;
  String? couponAmount;
  String? paymentTrack;
  String? paymentGateway;
  String? transactionId;
  String? orderStatus;
  String? paymentStatus;
  int? invoiceNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  String? type;
  dynamic note;
  dynamic selectedCustomer;
  Address? address;
  PaymentMeta? paymentMeta;

  PaymentDetails({
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
    this.address,
    this.paymentMeta,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
    id: json["id"],
    coupon: json["coupon"],
    couponAmount: json["coupon_amount"],
    paymentTrack: json["payment_track"],
    paymentGateway: json["payment_gateway"],
    transactionId: json["transaction_id"],
    orderStatus: json["order_status"],
    paymentStatus: json["payment_status"],
    invoiceNumber: json["invoice_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
    type: json["type"],
    note: json["note"],
    selectedCustomer: json["selected_customer"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    paymentMeta: json["payment_meta"] == null ? null : PaymentMeta.fromJson(json["payment_meta"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "coupon": coupon,
    "coupon_amount": couponAmount,
    "payment_track": paymentTrack,
    "payment_gateway": paymentGateway,
    "transaction_id": transactionId,
    "order_status": orderStatus,
    "payment_status": paymentStatus,
    "invoice_number": invoiceNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user_id": userId,
    "type": type,
    "note": note,
    "selected_customer": selectedCustomer,
    "address": address?.toJson(),
    "payment_meta": paymentMeta?.toJson(),
  };
}

class Address {
  int? id;
  int? orderId;
  String? name;
  String? email;
  String? phone;
  int? countryId;
  int? stateId;
  dynamic city;
  String? address;
  dynamic userId;
  String? zipcode;
  Country? country;
  Country? state;
  dynamic cityInfo;

  Address({
    this.id,
    this.orderId,
    this.name,
    this.email,
    this.phone,
    this.countryId,
    this.stateId,
    this.city,
    this.address,
    this.userId,
    this.zipcode,
    this.country,
    this.state,
    this.cityInfo,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    orderId: json["order_id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    countryId: json["country_id"],
    stateId: json["state_id"],
    city: json["city"],
    address: json["address"],
    userId: json["user_id"],
    zipcode: json["zipcode"],
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
    state: json["state"] == null ? null : Country.fromJson(json["state"]),
    cityInfo: json["city_info"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "name": name,
    "email": email,
    "phone": phone,
    "country_id": countryId,
    "state_id": stateId,
    "city": city,
    "address": address,
    "user_id": userId,
    "zipcode": zipcode,
    "country": country?.toJson(),
    "state": state?.toJson(),
    "city_info": cityInfo,
  };
}

class Country {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? status;
  int? countryId;

  Country({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.status,
    this.countryId,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    status: json["status"],
    countryId: json["country_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "status": status,
    "country_id": countryId,
  };
}

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
  String? taxType;
  Product? product;
  dynamic variant;

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
    this.variant,
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
    taxType: json["tax_type"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    variant: json["variant"],
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
    "tax_type": taxType,
    "product": product?.toJson(),
    "variant": variant,
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
  dynamic badgeId;
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
  String? image;
  dynamic badge;
  Uom? uom;
  dynamic campaignProduct;

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
    this.campaignProduct,
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
    image: json["image"],
    badge: json["badge"],
    uom: json["uom"] == null ? null : Uom.fromJson(json["uom"]),
    campaignProduct: json["campaign_product"],
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
    "image": image,
    "badge": badge,
    "uom": uom?.toJson(),
    "campaign_product": campaignProduct,
  };
}

class Uom {
  int? id;
  int? productId;
  int? unitId;
  int? quantity;
  Country? unit;

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
    unit: json["unit"] == null ? null : Country.fromJson(json["unit"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "unit_id": unitId,
    "quantity": quantity,
    "unit": unit?.toJson(),
  };
}

class OrderTrack {
  int? id;
  int? orderId;
  String? name;
  int? updatedBy;
  String? table;
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
    name: json["name"],
    updatedBy: json["updated_by"],
    table: json["table"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "name": name,
    "updated_by": updatedBy,
    "table": table,
    "created_at": createdAt?.toIso8601String(),
  };
}
