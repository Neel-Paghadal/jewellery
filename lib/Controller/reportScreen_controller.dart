import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Models/reportDetail_model.dart';
import 'package:http/http.dart' as http;

import '../Common/snackbar.dart';

class ReportScreenController extends GetxController {


  RxBool isLoaderShow = false.obs;

  String orderId = "";
  RxList<ReportDetail> reportDetail = <ReportDetail>[].obs;

  Future<void> handleRefresh() async {
    reportDetail.clear();
    isLoaderShow.value = true;
    getReportDetailCall(orderId);
    debugPrint("ScreenRefresh");
    return await Future.delayed(const Duration(seconds: 1));
  }

  getReportDetailCall(String orderId) async {

    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse("${ConstApi.baseUrl}api/Report/OrderDetails?orderId=$orderId"),
        headers: headers);
    if (response.statusCode == 200) {
      final responseData = reportDetailModelFromJson(response.body);
      debugPrint("REPORT DETAIL LIST $responseData");
      isLoaderShow.value = false;
      reportDetail.clear();
      reportDetail.addAll(responseData.users);
      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      isLoaderShow.value = false;
      // Error in API call
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    isLoaderShow.value = false;
  }




}
