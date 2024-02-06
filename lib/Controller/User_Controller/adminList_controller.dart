import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Models/adminList_model.dart';

class AdminListController extends GetxController {
  RxBool isLoaderShow = false.obs;

  RxList<AdminDetail> adminList = <AdminDetail>[].obs;

  getAdminCall(int pageIndex, int pageSize) async {
    if (adminList.isEmpty) {
      isLoaderShow.value = true;
    } else {
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
        Uri.parse(
            "http://208.64.33.118:8558/api/User/Admins?PageNumber=$pageIndex&PageSize=$pageSize"),
        headers: headers);
    if (response.statusCode == 200) {
      isLoaderShow.value = false;
      final responseData = adminDetailModelFromJson(response.body);
      debugPrint("ADMIN LIST " + responseData.toString());
      adminList.addAll(responseData.users);
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

  Future<void> releaseDeviceCall(String userId) async {

    String? token = await ConstPreferences().getToken();
    debugPrint(token);


    Map<String, dynamic> requestData = {
      "userId": userId,
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {

      final http.Response response = await http.post(
          Uri.parse(ConstApi.releaseDevice),
          headers: headers,
          body: jsonEncode(requestData));


      if (response.statusCode == 200) {
        debugPrint('Release device Response: ${response.body}');
        final responseData = json.decode(response.body)['message'];
        Utils().toastMessage(responseData);

        // Utils().snackBar(response.body, '');
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
        Utils().errorsnackBar(response.reasonPhrase.toString(), '');
      }
    } catch (e) {
      debugPrint('Error: $e');
      Utils().errorsnackBar(e.toString(), '');

    }
    debugPrint("Request Data : $requestData");
  }




}
