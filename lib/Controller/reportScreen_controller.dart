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

    final response = await http.get(Uri.parse(ConstApi.baseUrl+"/api/Report/OrderDetails?orderId=$orderId"),
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
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    isLoaderShow.value = false;
  }




}
