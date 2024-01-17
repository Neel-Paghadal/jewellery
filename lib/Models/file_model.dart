// To parse this JSON data, do
//
//     final fileUpload = fileUploadFromJson(jsonString);

import 'dart:convert';

FileUpload fileUploadFromJson(String str) => FileUpload.fromJson(json.decode(str));

String fileUploadToJson(FileUpload data) => json.encode(data.toJson());

class FileUpload {
  List<FileElement> files;

  FileUpload({
    required this.files,
  });

  factory FileUpload.fromJson(Map<String, dynamic> json) => FileUpload(
    files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
  };
}

class FileElement {
  String path;

  FileElement({
    required this.path,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "path": path,
  };
}
