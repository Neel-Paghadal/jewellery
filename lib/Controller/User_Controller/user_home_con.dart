


import 'package:get/get.dart';

class UserHomeCon extends GetxController{

  String selectedItem = "English";
  List<String> itemSort = ['English', 'ગુજરાતી', 'हिंदी'];

  List<Report> reportlist = <Report>[
    Report(designCode: 'Manga Mala', date: '02/01/2024',),
    Report(designCode: 'Manga Mala', date: '01/01/2024',),
    Report(designCode: 'Manga Mala', date: '29/12/2023',),
    Report(designCode: 'Kangan', date: '29/12/2023',),
    Report(designCode: 'mala', date: '20/12/2023',),

  ];

}

class Report {
  Report({required this.designCode, required this.date});
  final String designCode;
  final String date;

}