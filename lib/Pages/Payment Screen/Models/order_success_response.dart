import 'dart:convert';

OrderSuccessResponse orderSuccessResponseFromJson(String str) => OrderSuccessResponse.fromJson(json.decode(str));

String orderSuccessResponseToJson(OrderSuccessResponse data) => json.encode(data.toJson());

class OrderSuccessResponse {
  bool? success;
  String? type;
  int? orderId;
  dynamic? totalAmount;
  String? tested;
  String? secreteKey;
  int? invoiceNumber;
  DateTime? createdAt;
  String? hash;
  String? hashTwo;
  String? orderSecretId;
  String? transactionId;

  OrderSuccessResponse({
    this.success,
    this.type,
    this.orderId,
    this.totalAmount,
    this.tested,
    this.secreteKey,
    this.invoiceNumber,
    this.createdAt,
    this.hash,
    this.hashTwo,
    this.orderSecretId,
    this.transactionId
  });

  factory OrderSuccessResponse.fromJson(Map<String, dynamic> json) => OrderSuccessResponse(
    success: json["success"],
    type: json["type"],
    orderId: json["order_id"],
    totalAmount: json["total_amount"],
    tested: json["tested"],
    secreteKey: json["secrete_key"],
    invoiceNumber: json["invoice_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    hash: json["hash"],
    hashTwo: json["hash-two"],
  );

  Map<String, dynamic> toJson() => {
    "success": "complete",
    "status": "complete",
    "type": type,
    "order_id": orderId,
    "total_amount": totalAmount,
    "tested": tested,
    "secrete_key": secreteKey,
    "invoice_number": invoiceNumber,
    "created_at": createdAt?.toIso8601String(),
    "hash": hash,
    "hash-two": hashTwo,
    "order_secret_id": secreteKey,
    "transaction_id": transactionId
  };
}
