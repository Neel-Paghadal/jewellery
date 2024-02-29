// To parse this JSON data, do
//
//     final productDetail = productDetailFromJson(jsonString);

import 'dart:convert';

ProductDetail productDetailFromJson(String str) => ProductDetail.fromJson(json.decode(str));

String productDetailToJson(ProductDetail data) => json.encode(data.toJson());

class ProductDetail {
  OrderDetail order;

  ProductDetail({
    required this.order,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
    order: OrderDetail.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "order": order.toJson(),
  };
}

class OrderDetail {
  String id;
  String name;
  String party;
  double carat;
  double weight;
  String deliveryDate;
  String description;
  String image;
  String dateCreated;
  String notes;
  List<OrderImage> orderImages;

  OrderDetail({
    required this.id,
    required this.name,
    required this.party,
    required this.carat,
    required this.weight,
    required this.deliveryDate,
    required this.description,
    required this.image,
    required this.dateCreated,
    required this.notes,
    required this.orderImages,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["id"],
    name: json["name"],
    party: json["party"],
    carat: json["carat"],
    weight: json["weight"]?.toDouble(),
    deliveryDate: json["deliveryDate"],
    description: json["description"],
    image: json["image"],
    dateCreated: json["dateCreated"],
    notes: json["notes"],
    orderImages: List<OrderImage>.from(json["orderImages"].map((x) => OrderImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "party": party,
    "carat": carat,
    "weight": weight,
    "deliveryDate": deliveryDate,
    "description": description,
    "image": image,
    "dateCreated": dateCreated,
    "notes" : notes,
    "orderImages": List<dynamic>.from(orderImages.map((x) => x.toJson())),
  };
}

class OrderImage {
  String id;
  String path;
  String dateCreated;

  OrderImage({
    required this.id,
    required this.path,
    required this.dateCreated,
  });

  factory OrderImage.fromJson(Map<String, dynamic> json) => OrderImage(
    id: json["id"],
    path: json["path"],
    dateCreated: json["dateCreated"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "path": path,
    "dateCreated": dateCreated,
  };
}
