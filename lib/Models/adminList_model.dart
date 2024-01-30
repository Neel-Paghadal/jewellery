// To parse this JSON data, do
//
//     final adminDetailModel = adminDetailModelFromJson(jsonString);

import 'dart:convert';

AdminDetailModel adminDetailModelFromJson(String str) => AdminDetailModel.fromJson(json.decode(str));

String adminDetailModelToJson(AdminDetailModel data) => json.encode(data.toJson());

class AdminDetailModel {
  List<AdminDetail> users;

  AdminDetailModel({
    required this.users,
  });

  factory AdminDetailModel.fromJson(Map<String, dynamic> json) => AdminDetailModel(
    users: List<AdminDetail>.from(json["users"].map((x) => AdminDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class AdminDetail {
  String id;
  String firstName;
  String lastName;
  String mobileNumber;
  String address;
  String referenceName;
  DateTime addedOn;

  AdminDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.address,
    required this.referenceName,
    required this.addedOn,
  });

  factory AdminDetail.fromJson(Map<String, dynamic> json) => AdminDetail(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    mobileNumber: json["mobileNumber"],
    address: json["address"],
    referenceName: json["referenceName"],
    addedOn: DateTime.parse(json["addedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "mobileNumber": mobileNumber,
    "address": address,
    "referenceName": referenceName,
    "addedOn": addedOn.toIso8601String(),
  };
}
