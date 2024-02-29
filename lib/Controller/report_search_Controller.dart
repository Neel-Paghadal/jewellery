import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Models/ordersReport_model.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Models/party_model.dart';
import '../Common/snackbar.dart';

class ReportSearchController extends GetxController {


  RxBool isLoaderShow = false.obs;
  RxBool isFilterApplyed = false.obs;
  RxBool isDropLoader = false.obs;
  RxList<OrderReport> orderReportList = <OrderReport>[].obs;
  RxList<String> userListDrop = <String>[].obs;

  String? partyName;

  getPartyCall() async {
    isDropLoader.value = true;
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse(ConstApi.getParty),
        headers: headers);
    if (response.statusCode == 200) {
      isDropLoader.value = false;

      debugPrint(response.body);
      final responseData = partyModelFromJson(response.body);
      debugPrint("PARTY LIST $responseData");
      userListDrop.clear();
      userListDrop.addAll(responseData.parties);
      if(userListDrop.isEmpty){
        Utils().toastMessage("No Party Found");
      }
      debugPrint('Response: ${response.body}');
      // Process the data as needed
      isDropLoader.value = false;

    } else {
      // Error in API call
      isDropLoader.value = false;
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    isDropLoader.value = false;
  }


  getReportCall(String partyName,var startD,var endD,int pageIndex, int pageSize) async {
    if (orderReportList.isEmpty) {
      isLoaderShow.value = true;
    } else {
      isLoaderShow.value = false;
    }
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    Map<String, dynamic> requestData = {
      "partyName": partyName,
      "startDate": startD,
      "endDate": endD,
      "pageNumber": pageIndex,
      "pageSize": pageSize
    };

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(Uri.parse(ConstApi.getReport),
        headers: headers, body: jsonEncode(requestData));
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
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    isLoaderShow.value = false;
  }

  getFilterReportCall(String partyName,String orderStatus, var startD,var endD,int pageIndex, int pageSize) async {
    if (orderReportList.isEmpty) {
      isLoaderShow.value = true;
    } else {
      isLoaderShow.value = false;
    }
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    Map<String, dynamic> requestData = {
      "partyName": partyName,
      "orderStatus" : orderStatus,
      "startDate": startD,
      "endDate": endD,
      "pageNumber": pageIndex,
      "pageSize": pageSize
    };

    debugPrint(requestData.toString());
    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(Uri.parse(ConstApi.getReport),
        headers: headers, body: jsonEncode(requestData));
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
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    isLoaderShow.value = false;
  }


}

