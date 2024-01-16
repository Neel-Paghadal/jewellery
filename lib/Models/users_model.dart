// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  List<UsersData> users;

  Users({
    required this.users,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    users: List<UsersData>.from(json["users"].map((x) => UsersData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class UsersData {
  String id;
  String name;

  UsersData({
    required this.id,
    required this.name,
  });

  factory UsersData.fromJson(Map<String, dynamic> json) => UsersData(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
