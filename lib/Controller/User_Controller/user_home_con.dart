import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/ConstFile/constApi.dart';
import '../../Common/snackbar.dart';
import '../../ConstFile/constPreferences.dart';
import '../../Models/userHome_model.dart';

class UserHomeCon extends GetxController {
  String selectedItem = "English";
  List<String> itemSort = ['English', 'ગુજરાતી', 'हिंदी'];
  TextEditingController codeController = TextEditingController();
  RxList<Order> userHome = <Order>[].obs;
  RxBool isProductAvailable = false.obs;
  String code = "";


  /*Future<String> getCode() async {
    return await ConstPreferences().getCode().toString();
  }*/


  getProductCall(String code) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse(ConstApi.baseUrl+"api/Order/GetOrderByCode?code=$code"),
        headers: headers);
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final responseData = userHomeFromJson(response.body);
      debugPrint("HOME LIST " + responseData.toString());
      ConstPreferences().setCode(codeController.text);
      isProductAvailable.value = true;
      userHome.clear();
      userHome.add(responseData.order);
      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call.
      Utils().toastMessage(json.decode(response.body)['error']);
      // if(json.decode(response.body)['error'] != null){
        getProductHomeCall();
      // }
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }

  }

  getProductHomeCall() async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse(ConstApi.getUserOrder),
        headers: headers);

    if (response.statusCode == 200) {
      debugPrint(response.body);
     final responseData = userHomeFromJson(response.body);
      isProductAvailable.value = true;
      debugPrint("HOME LIST " + responseData.toString());
        userHome.clear();
        userHome.add(responseData.order);
        debugPrint('Response: ${response.body}');

      // Process the data as needed
    } else {
      // Error in API call.
      Utils().toastMessage(json.decode(response.body)['error']);
      codeController.clear();

      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
  }
}
