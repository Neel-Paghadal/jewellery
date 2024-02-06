// To parse this JSON data, do
//
//     final partyModel = partyModelFromJson(jsonString);

import 'dart:convert';

PartyModel partyModelFromJson(String str) => PartyModel.fromJson(json.decode(str));

String partyModelToJson(PartyModel data) => json.encode(data.toJson());

class PartyModel {
  List<String> parties;

  PartyModel({
    required this.parties,
  });

  factory PartyModel.fromJson(Map<String, dynamic> json) => PartyModel(
    parties: List<String>.from(json["parties"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "parties": List<dynamic>.from(parties.map((x) => x)),
  };
}
