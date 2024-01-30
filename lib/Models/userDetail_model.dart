// To parse this JSON data, do
//
//     final userDetailModel = userDetailModelFromJson(jsonString);

import 'dart:convert';

UserDetailModel userDetailModelFromJson(String str) => UserDetailModel.fromJson(json.decode(str));

String userDetailModelToJson(UserDetailModel data) => json.encode(data.toJson());

class UserDetailModel {
  List<UserDetail> users;

  UserDetailModel({
    required this.users,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) => UserDetailModel(
    users: List<UserDetail>.from(json["users"].map((x) => UserDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class UserDetail {
  String id;
  String firstName;
  String lastName;
  String mobileNumber;
  String address;
  String referenceName;
  DateTime addedOn;

  UserDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.address,
    required this.referenceName,
    required this.addedOn,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
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
