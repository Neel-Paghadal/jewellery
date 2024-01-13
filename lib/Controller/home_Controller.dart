import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';


class HomeController extends GetxController{


  RxBool loading = false.obs;


  Future<void> getOrderCall() async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };


    final response =  await http.get(Uri.parse(ConstApi.getOrder),headers: headers);
    if (response.statusCode == 200) {
      // Successful API call
      print('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call
      print('Error: ${response.statusCode}');
      print('Error body: ${response.body}');
    }
  }

}