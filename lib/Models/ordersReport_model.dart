// To parse this JSON data, do
//
//     final ordersReportModel = ordersReportModelFromJson(jsonString);

import 'dart:convert';

OrdersReportModel ordersReportModelFromJson(String str) =>
    OrdersReportModel.fromJson(json.decode(str));

String ordersReportModelToJson(OrdersReportModel data) =>
    json.encode(data.toJson());

class OrdersReportModel {
  List<OrderReport> orders;

  OrdersReportModel({
    required this.orders,
  });

  factory OrdersReportModel.fromJson(Map<String, dynamic> json) =>
      OrdersReportModel(
        orders: List<OrderReport>.from(
            json["orders"].map((x) => OrderReport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
}

class OrderReport {
  String id;
  String orderId;
  String image;
  String dateCreated;
  String orderStatus;
  String party;

  OrderReport({
    required this.id,
    required this.orderId,
    required this.image,
    required this.dateCreated,
    required this.orderStatus,
    required this.party,
  });

  factory OrderReport.fromJson(Map<String, dynamic> json) => OrderReport(
    id: json["id"],
    orderId: json["orderId"],
    image: json["image"],
    dateCreated: json["dateCreated"],
    orderStatus: json["orderStatus"],
    party: json["party"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "image": image,
    "dateCreated": dateCreated,
    "orderStatus": orderStatus,
    "party": party
  };
}
