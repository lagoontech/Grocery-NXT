// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

OrderListModel orderListModelFromJson(String str) => OrderListModel.fromJson(json.decode(str));

String orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  int? currentPage;
  List<Order>? orders;
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

  OrderListModel({
    this.currentPage,
    this.orders,
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

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
    currentPage: json["current_page"],
    orders: json["data"] == null ? [] : List<Order>.from(json["data"]!.map((x) => Order.fromJson(x))),
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
    "Orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
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

class Order {
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
  dynamic type;
  dynamic note;
  dynamic selectedCustomer;
  PaymentMeta? paymentMeta;
  List<OrderTrack>? orderTrack;

  Order({
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

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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
    paymentMeta: json["payment_meta"] == null ? null : PaymentMeta.fromJson(json["payment_meta"]),
    orderTrack: json["order_track"] == null ? [] : List<OrderTrack>.from(json["order_track"]!.map((x) => OrderTrack.fromJson(x))),
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
    "payment_meta": paymentMeta?.toJson(),
    "order_track": orderTrack == null ? [] : List<dynamic>.from(orderTrack!.map((x) => x.toJson())),
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
