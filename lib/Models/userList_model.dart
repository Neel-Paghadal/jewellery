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

  User({
    required this.id,
    required this.userName,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userName: json["userName"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userName": userName,
    "status": status,
  };
}
