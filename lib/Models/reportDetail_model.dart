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
  String orderStatus;
  String orderCreatedDate;
  String assignDate;
  String completedDate;
  String cancelledDate;
  String cancelReason;

  ReportDetail({
    required this.id,
    required this.name,
    required this.orderStatus,
    required this.orderCreatedDate,
    required this.assignDate,
    required this.completedDate,
    required this.cancelledDate,
    required this.cancelReason,
  });

  factory ReportDetail.fromJson(Map<String, dynamic> json) => ReportDetail(
    id: json["id"],
    name: json["name"],
    orderStatus: json["orderStatus"],
    orderCreatedDate: json["orderCreatedDate"],
    assignDate: json["assignDate"],
    completedDate: json["completedDate"],
    cancelledDate: json["cancelledDate"],
    cancelReason: json["cancelReason"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "orderStatus": orderStatus,
    "orderCreatedDate": orderCreatedDate,
    "assignDate": assignDate,
    "completedDate": completedDate,
    "cancelledDate": cancelledDate,
    "cancelReason": cancelReason,
  };
}
