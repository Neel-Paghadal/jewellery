// To parse this JSON data, do
//
//     final userHome = userHomeFromJson(jsonString);

import 'dart:convert';

UserHome userHomeFromJson(String str) => UserHome.fromJson(json.decode(str));

String userHomeToJson(UserHome data) => json.encode(data.toJson());

class UserHome {
  Order order;

  UserHome({
    required this.order,
  });

  factory UserHome.fromJson(Map<String, dynamic> json) => UserHome(
    order: Order.fromJson(json["order"]),
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

  Order({
    required this.name,
    required this.id,
    required this.image,
    required this.deliveryDate,
    required this.orderUserId,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    name: json["name"],
    id: json["id"],
    image: json["image"],
    deliveryDate: json["deliveryDate"],
    orderUserId: json["orderUserId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "image": image,
    "deliveryDate": deliveryDate,
    "orderUserId": orderUserId,
  };
}
