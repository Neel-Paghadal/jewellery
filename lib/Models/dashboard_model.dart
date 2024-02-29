// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  List<Order> orders;

  Dashboard({
    required this.orders,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  String id;
  String name;
  String party;
  String image;
  String dateCreated;
  String orderId;
  String orderStatus;

  Order({
    required this.id,
    required this.name,
    required this.party,
    required this.image,
    required this.dateCreated,
    required this.orderId,
    required this.orderStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        name: json["name"],
        party: json["party"],
        image: json["image"],
        dateCreated: json["dateCreated"],
        orderId: json['orderId'],
        orderStatus: json["orderStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "party": party,
        "image": image,
        "dateCreated": dateCreated,
        "orderId": orderId,
        "orderStatus": orderStatus,
      };
}
