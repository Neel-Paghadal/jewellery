

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Models/userDetail_model.dart';

class UserListScreenController extends GetxController{

  RxBool isLoaderShow = false.obs;
  RxList<UserDetail> usersList = <UserDetail>[].obs;

  int pageIndex = 0;
  int pageSize = 10;
  RxBool loadingPage = false.obs;



  Future<void> handleRefresh() async {
    pageIndex = 1;
    pageSize = 10;

    usersList.clear();
    getUserCall(
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
      final RxList<UserDetail> products = await getUserCall(
        pageIndex,
        pageSize,
      );
      usersList.addAll(products);
    } catch (e) {
      // Handle errors
      debugPrint('Error loading products: $e');
    } finally {
      loadingPage.value = false;
    }
  }

  getUserCall(int pageIndex, int pageSize) async {
    if(usersList.isEmpty){
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
        Uri.parse("${ConstApi.baseUrl}api/User/Users?PageNumber=$pageIndex&PageSize=$pageSize"),
        headers: headers);
    if (response.statusCode == 200) {
      isLoaderShow.value = false;
      final responseData = userDetailModelFromJson(response.body);
      debugPrint("USER LIST $responseData");
      usersList.addAll(responseData.users);
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


  Future<void> deleteUserCall(String userId) async {

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
        usersList.clear();
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

}