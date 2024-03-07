import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Models/adminList_model.dart';

class AdminListController extends GetxController {
  RxBool isLoaderShow = false.obs;

  RxList<AdminDetail> adminList = <AdminDetail>[].obs;

  int pageIndex = 0;
  int pageSize = 10;

  RxBool loadingPage = false.obs;


  Future<void> handleRefresh() async {
    pageIndex = 1;
    pageSize = 10;

    adminList.clear();
    getAdminCall(
      pageIndex,
      pageSize,
    );
    debugPrint("ScreenRefresh");
    return await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> loadProducts() async {
    loadingPage.value = true;
    pageIndex++;

    debugPrint("Page Order index$pageIndex");
    try {
      final RxList<AdminDetail> products =
      await getAdminCall(
        pageIndex,
        pageSize,
      );
        adminList.addAll(products);
    } catch (e) {
      // Handle errors
      debugPrint('Error loading products: $e');
    } finally {
      loadingPage.value = false;
    }
  }



  Future<void> deleteAdminCall(String userId) async {

    String? token = await ConstPreferences().getToken();
    debugPrint(token);


    Map<String, dynamic> requestData = {
      "id": userId,
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {

      final http.Response response = await http.post(
          Uri.parse(ConstApi.deleteUserAdmin+userId),
          headers: headers,
          body: jsonEncode(requestData));


      if (response.statusCode == 200) {
        debugPrint('Delete User Response: ${response.body}');
        final responseData = json.decode(response.body)['message'];
        Utils().toastMessage(responseData);
        adminList.clear();
        pageIndex = 0;
        pageSize = 10;
        loadProducts();

        // Utils().snackBar(response.body, '');
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
        Utils().errorsnackBar(response.reasonPhrase.toString(), '');
      }
      if(response.statusCode == 401 || response.statusCode == 403){
        Utils().toastMessage("Please Relogin Account");
        ConstPreferences().clearPreferences();
        SystemNavigator.pop();
      }
    } catch (e) {
      debugPrint('Error: $e');
      Utils().errorsnackBar(e.toString(), '');

    }
    debugPrint("Request Data : $requestData");
  }











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
        Uri.parse(ConstApi.baseUrl+"/api/User/Admins?PageNumber=$pageIndex&PageSize=$pageSize"),
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
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
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
      if(response.statusCode == 401 || response.statusCode == 403){
        Utils().toastMessage("Please Relogin Account");
        ConstPreferences().clearPreferences();
        SystemNavigator.pop();
      }
    } catch (e) {
      debugPrint('Error: $e');
      Utils().errorsnackBar(e.toString(), '');

    }
    debugPrint("Request Data : $requestData");
  }




}
