// To parse this JSON data, do
//
//     final ordersReportModel = ordersReportModelFromJson(jsonString);

import 'dart:convert';

OrdersReportModel ordersReportModelFromJson(String str) => OrdersReportModel.fromJson(json.decode(str));

String ordersReportModelToJson(OrdersReportModel data) => json.encode(data.toJson());

class OrdersReportModel {
  List<OrderReport> orders;

  OrdersReportModel({
    required this.orders,
  });

  factory OrdersReportModel.fromJson(Map<String, dynamic> json) => OrdersReportModel(
    orders: List<OrderReport>.from(json["orders"].map((x) => OrderReport.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
}

class OrderReport {
  String id;
  int orderId;
  String image;
  String dateCreated;
  String status;

  OrderReport({
    required this.id,
    required this.orderId,
    required this.image,
    required this.dateCreated,
    required this.status,
  });

  factory OrderReport.fromJson(Map<String, dynamic> json) => OrderReport(
    id: json["id"],
    orderId: json["orderId"],
    image: json["image"],
    dateCreated: json["dateCreated"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "image": image,
    "dateCreated": dateCreated,
    "status": status,
  };
}
