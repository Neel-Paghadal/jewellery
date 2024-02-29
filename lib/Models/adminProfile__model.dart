// To parse this JSON data, do
//
//     final adminProfileModel = adminProfileModelFromJson(jsonString);

import 'dart:convert';

AdminProfileModel adminProfileModelFromJson(String str) => AdminProfileModel.fromJson(json.decode(str));

String adminProfileModelToJson(AdminProfileModel data) => json.encode(data.toJson());

class AdminProfileModel {
  AdminProfile user;

  AdminProfileModel({
    required this.user,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) => AdminProfileModel(
    user: AdminProfile.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class AdminProfile {
  String id;
  String firstName;
  String lastName;
  String mobileNumber;
  String address;
  String referenceName;
  String profileImage;
  String addedOn;
  int role;
  dynamic userBankDetail;
  List<dynamic> userDocuments;

  AdminProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.address,
    required this.referenceName,
    required this.profileImage,
    required this.addedOn,
    required this.role,
    required this.userBankDetail,
    required this.userDocuments,
  });

  factory AdminProfile.fromJson(Map<String, dynamic> json) => AdminProfile(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    mobileNumber: json["mobileNumber"],
    address: json["address"],
    referenceName: json["referenceName"],
    profileImage: json["profileImage"],
    addedOn: json["addedOn"],
    role: json["role"],
    userBankDetail: json["userBankDetail"],
    userDocuments: List<dynamic>.from(json["userDocuments"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "mobileNumber": mobileNumber,
    "address": address,
    "referenceName": referenceName,
    "profileImage": profileImage,
    "addedOn": addedOn,
    "role": role,
    "userBankDetail": userBankDetail,
    "userDocuments": List<dynamic>.from(userDocuments.map((x) => x)),
  };
}
