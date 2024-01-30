import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Common/snackbar.dart';
import '../../ConstFile/constPreferences.dart';
import '../../Models/userHome_model.dart';

class UserHomeCon extends GetxController {
  String selectedItem = "English";
  List<String> itemSort = ['English', 'ગુજરાતી', 'हिंदी'];
  TextEditingController codeController = TextEditingController();
  RxList<Order> userHome = <Order>[].obs;

  List<Report> reportlist = <Report>[
    Report(
      designCode: 'Manga Mala',
      date: '02/01/2024',
    ),
    Report(
      designCode: 'Manga Mala',
      date: '01/01/2024',
    ),
    Report(
      designCode: 'Manga Mala',
      date: '29/12/2023',
    ),
    Report(
      designCode: 'Kangan',
      date: '29/12/2023',
    ),
    Report(
      designCode: 'mala',
      date: '20/12/2023',
    ),
  ];

  getProductCall(String code) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse(
            "http://208.64.33.118:8558/api/Order/GetOrderByCode?code=$code"),
        headers: headers);

    if (response.statusCode == 200) {
      debugPrint(response.body);
      final responseData = userHomeFromJson(response.body);
      debugPrint("HOME LIST " + responseData.toString());
      userHome.clear();
      userHome.add(responseData.order);

      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call.
      Utils().toastMessage(json.decode(response.body)['error']);
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
  }
}

class Report {
  Report({required this.designCode, required this.date});
  final String designCode;
  final String date;
}
