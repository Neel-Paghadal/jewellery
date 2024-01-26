import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Models/dashboard_model.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxList<Order> homeList = <Order>[].obs;
  RxBool isLoaderShow = false.obs;
  RxBool isShow = false.obs;
  void checkUser() async {
    var role = await ConstPreferences().getRole();
    debugPrint("Role : $role");
    if (role == 'Admin') {
    } else if (role == 'SuperAdmin') {
      isShow.value = true;
    }
  }

  getOrderCall(int pageIndex, int pageSize) async {
    isLoaderShow.value = true;
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse("http://208.64.33.118:8558/api/Order/Orders?PageNumber=$pageIndex&PageSize=$pageSize"),
        headers: headers);
    if (response.statusCode == 200) {
      isLoaderShow.value = false;
      final responseData = dashboardFromJson(response.body);
      debugPrint("HOME LIST " + responseData.toString());
      homeList.addAll(responseData.orders);
      debugPrint("HOME LIST " + homeList[0].name.toString());
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

  // getOrderCall(int pageIndex, int pageSize) async {
  //   String? token = await ConstPreferences().getToken();
  //   debugPrint(token);
  //
  //   // Set up headers with the token
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };
  //
  //
  //   final response =  await http.get(Uri.parse("http://208.64.33.118:8558/api/Order/Orders?PageNumber=$pageIndex&PageSize=$pageSize"),headers: headers);
  //   if (response.statusCode == 200) {
  //     final responseData = dashboardFromJson(response.body);
  //     debugPrint("HOME LIST "+responseData.toString());
  //     homeList.clear();
  //     homeList.addAll(responseData.orders);
  //     // Successful API call
  //     debugPrint("HOME LIST "+homeList[0].name.toString());
  //     debugPrint("HOME LIST "+homeList[1].name.toString());
  //
  //     debugPrint('Response: ${response.body}');
  //     // Process the data as needed
  //   } else {
  //     // Error in API call
  //     debugPrint('Error: ${response.statusCode}');
  //     debugPrint('Error body: ${response.body}');
  //   }
  // }
}
