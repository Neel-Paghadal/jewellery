import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Models/ordersReport_model.dart';
import 'package:http/http.dart' as http;

class ReportSearchController extends GetxController {
  List<Report> reportlist = <Report>[
    Report(designCode: '# 2352', date: 'Create Date : 02/01/2024', btnName: 'Completed'),
    Report(designCode: '# 2354', date: 'Create Date : 01/01/2024', btnName: 'Completed'),
    Report(designCode: '# 4563', date: 'Create Date : 29/12/2023', btnName: 'Pending'),
    Report(designCode: '# 2564', date: 'Create Date : 29/12/2023', btnName: 'Completed'),
    Report(designCode: '# 5648', date: 'Create Date : 20/12/2023', btnName: 'Cancelled'),

  ];


  RxBool isLoaderShow = false.obs;

  RxList<OrderReport> orderReportList = <OrderReport>[].obs;


  getReportCall(int pageIndex, int pageSize) async {
    if(orderReportList.isEmpty){
      isLoaderShow.value = true;
    }else{
      isLoaderShow.value = false;
    }
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse("http://208.64.33.118:8558/api/Report/Orders?PageNumber=$pageIndex&PageSize=$pageSize"),
        headers: headers);
    if (response.statusCode == 200) {
      isLoaderShow.value = false;
      final responseData = ordersReportModelFromJson(response.body);
      debugPrint("ADMIN LIST " + responseData.toString());
      orderReportList.addAll(responseData.orders);
      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      isLoaderShow.value = false;
      // Error in API call
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    isLoaderShow.value = false;
  }






}

class Report {
  Report({required this.btnName, required this.designCode, required this.date});
  final String designCode;
  final String date;
  final String btnName;
}