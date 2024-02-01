import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Models/reportDetail_model.dart';
import 'package:http/http.dart' as http;

class ReportScreenController extends GetxController {


  RxBool isLoaderShow = false.obs;

  RxList<ReportDetail> reportDetail = <ReportDetail>[].obs;

  getReportDetailCall(String orderId) async {
    if(reportDetail.isEmpty){
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
        Uri.parse("http://208.64.33.118:8558/api/Report/OrderDetails?orderId=$orderId"),
        headers: headers);
    if (response.statusCode == 200) {
      isLoaderShow.value = false;
      final responseData = reportDetailModelFromJson(response.body);
      debugPrint("REPORT DETAIL LIST " + responseData.toString());
      reportDetail.addAll(responseData.users);
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
