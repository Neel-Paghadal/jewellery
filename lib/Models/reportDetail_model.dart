// To parse this JSON data, do
//
//     final reportDetailModel = reportDetailModelFromJson(jsonString);

import 'dart:convert';

ReportDetailModel reportDetailModelFromJson(String str) => ReportDetailModel.fromJson(json.decode(str));

String reportDetailModelToJson(ReportDetailModel data) => json.encode(data.toJson());

class ReportDetailModel {
  List<ReportDetail> users;

  ReportDetailModel({
    required this.users,
  });

  factory ReportDetailModel.fromJson(Map<String, dynamic> json) => ReportDetailModel(
    users: List<ReportDetail>.from(json["users"].map((x) => ReportDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class ReportDetail {
  String id;
  String name;
  String dateCreated;
  String completedDate;
  String cancelledDate;

  ReportDetail({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.completedDate,
    required this.cancelledDate,
  });

  factory ReportDetail.fromJson(Map<String, dynamic> json) => ReportDetail(
    id: json["id"],
    name: json["name"],
    dateCreated: json["dateCreated"],
    completedDate: json["completedDate"],
    cancelledDate: json["cancelledDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "dateCreated": dateCreated,
    "completedDate": completedDate,
    "cancelledDate": cancelledDate,
  };
}
