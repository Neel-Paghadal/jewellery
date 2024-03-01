// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersListFromJson(String str) => Users.fromJson(json.decode(str));

String usersListToJson(Users data) => json.encode(data.toJson());

class Users {
  List<User> users;

  Users({
    required this.users,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        users: List<User>.from(json["user"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  String id;
  String userName;
  String status;
  String code;
  String reason;
  String notes;
  String userId;
  bool needToReassign;

  User(
      {required this.id,
      required this.userName,
      required this.status,
      required this.code,
      required this.reason,
      required this.notes,
      required this.userId,
      required this.needToReassign});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      userName: json["userName"],
      status: json["status"],
      code: json["code"],
      reason: (json["reason"] == null || json['reason'] == "")
          ? ""
          : json["reason"],
      notes:
          (json["notes"] == null || json['notes'] == "") ? "" : json["notes"],
      userId: json["userId"],
      needToReassign: json["needToReassign"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "status": status,
        "code": code,
        "reason": reason,
        "Notes": notes,
        "userId": userId,
        "needToReassign": needToReassign,
      };
}
