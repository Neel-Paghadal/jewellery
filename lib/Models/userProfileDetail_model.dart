// To parse this JSON data, do
//
//     final userProfileDetailModel = userProfileDetailModelFromJson(jsonString);

import 'dart:convert';

UserProfileDetailModel userProfileDetailModelFromJson(String str) => UserProfileDetailModel.fromJson(json.decode(str));

String userProfileDetailModelToJson(UserProfileDetailModel data) => json.encode(data.toJson());

class UserProfileDetailModel {
  UserProfile user;

  UserProfileDetailModel({
    required this.user,
  });

  factory UserProfileDetailModel.fromJson(Map<String, dynamic> json) => UserProfileDetailModel(
    user: UserProfile.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class UserProfile {
  String id;
  String firstName;
  String lastName;
  String mobileNumber;
  String address;
  String referenceName;
  String profileImage;
  String addedOn;
  int role;
  UserBankDetail userBankDetail;
  List<UserDocument> userDocuments;

  UserProfile({
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

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    mobileNumber: json["mobileNumber"],
    address: json["address"],
    referenceName: json["referenceName"],
    profileImage: json["profileImage"],
    addedOn: json["addedOn"],
    role: json["role"],
    userBankDetail: UserBankDetail.fromJson(json["userBankDetail"]),
    userDocuments: List<UserDocument>.from(json["userDocuments"].map((x) => UserDocument.fromJson(x))),
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
    "userBankDetail": userBankDetail.toJson(),
    "userDocuments": List<dynamic>.from(userDocuments.map((x) => x.toJson())),
  };
}

class UserBankDetail {
  String name;
  String accountNumber;
  String ifsc;
  String brachName;
  String accountHolderName;

  UserBankDetail({
    required this.name,
    required this.accountNumber,
    required this.ifsc,
    required this.brachName,
    required this.accountHolderName,
  });

  factory UserBankDetail.fromJson(Map<String, dynamic> json) => UserBankDetail(
    name: json["name"],
    accountNumber: json["accountNumber"],
    ifsc: json["ifsc"],
    brachName: json["brachName"],
    accountHolderName: json["accountHolderName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "accountNumber": accountNumber,
    "ifsc": ifsc,
    "brachName": brachName,
    "accountHolderName": accountHolderName,
  };
}

class UserDocument {
  String document;
  int documentType;

  UserDocument({
    required this.document,
    required this.documentType,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) => UserDocument(
    document: json["document"],
    documentType: json["documentType"],
  );

  Map<String, dynamic> toJson() => {
    "document": document,
    "documentType": documentType,
  };
}
