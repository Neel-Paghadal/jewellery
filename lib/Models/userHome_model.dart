// To parse this JSON data, do
//
//     final userHome = userHomeFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_utils/get_utils.dart';

UserHome userHomeFromJson(String str) => UserHome.fromJson(json.decode(str));

String userHomeToJson(UserHome data) => json.encode(data.toJson());

class UserHome {
  Order order;

  UserHome({
    required this.order,
  });

  factory UserHome.fromJson(Map<String, dynamic> json) => UserHome(
    order: (json['user'].length) == 0 ? json["user"] : Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "order": order.toJson(),
  };
}

class Order {
  String name;
  String id;
  String image;
  String deliveryDate;
  String orderUserId;
  String notes;

  Order({
    required this.name,
    required this.id,
    required this.image,
    required this.deliveryDate,
    required this.orderUserId,
    required this.notes
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    name: json["name"],
    id: json["id"],
    image: json["image"],
    deliveryDate: json["deliveryDate"],
    orderUserId: json["orderUserId"],
    notes: (json["notes"] == null || json["notes"] == "null") ? "" : json["notes"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "image": image,
    "deliveryDate": deliveryDate,
    "orderUserId": orderUserId,
    "notes" : notes
  };
}
