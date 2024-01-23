
import 'dart:convert';

import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Controller/User_Controller/user_home_con.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Models/product_detail_model.dart';
import 'package:jewellery_user/Screen/User_screen/user_home.dart';

import '../../ConstFile/constApi.dart';
import '../../Screen/User_screen/prodcut_detail.dart';

class UserProductController extends GetxController{
  UserHomeCon userHomeCon = Get.put(UserHomeCon());
  HomeController homeController = Get.put(HomeController());
  TextEditingController reasonController = TextEditingController();
  var orderUserId;
  var design;
  var carat;
  var weight;
  var createDate;
  var deliveryDate;
  var description;
  RxList<Order> productDetail = <Order>[].obs;

  void clearData(){
      productDetail.clear();
      userHomeCon.userHome.clear();
      userHomeCon.codeController.clear();
      reasonController.clear();
  }

  getProductDetailCall(String id) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };


    final response = await http.get(
        Uri.parse("http://208.64.33.118:8558/api/Order/GetOrderDetails?orderId=$id"),
        headers: headers);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final responseData = productDetailFromJson(response.body);
      debugPrint("HOME LIST " + responseData.toString());
      Get.to(const ProductDetailPage());
      productDetail.clear();
      productDetail.add(responseData.order);
      design = productDetail[0].name;
      carat = productDetail[0].carat.toString();
      weight = productDetail[0].weight.toString();
      createDate = productDetail[0].dateCreated.toString();
      deliveryDate = productDetail[0].deliveryDate.toString();
      description = productDetail[0].description.toString();

      // debugPrint("HOME LIST " + userList[0].userName.toString());

      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call.
      Utils().toastMessage(response.body);
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
  }


  Future<void> assignComplete(
      String id,String reason ) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    var url = Uri.parse(ConstApi.orderComplete);

    Map<String, String> requestBody = {
      "Id":id,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    debugPrint("Request Body :$requestBody");

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successful API call
        var responseBody = json.decode(response.body);
        reasonController.clear();
        Get.to(() => const UserHome());
        debugPrint('Response: $responseBody');
        Utils().toastMessage("Order assign Successfully");
        clearData();
      } else {
        // Failed API call
        debugPrint(
            'Failed to make API call. Status code: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        Utils().toastMessage(response.body);
      }
    } catch (error) {
      debugPrint('Error making API call: $error');
    }

    homeController.loading.value = false;
  }
  Future<void> assignCancel(
      String id,String reason ) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    var url = Uri.parse(ConstApi.orderCancel);

    Map<String, String> requestBody = {
      "Id":id,
      "Reason":reason
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    debugPrint("Request Body :$requestBody");

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successful API call
        var responseBody = json.decode(response.body);
        reasonController.clear();
        Get.to(() => const UserHome());
        debugPrint('Response: $responseBody');
        Utils().toastMessage("Order Cancel Successfully");
        clearData();
      } else {
        // Failed API call
        debugPrint(
            'Failed to make API call. Status code: ${response.statusCode}');
        Utils().toastMessage(response.body);
      }
    } catch (error) {
      debugPrint('Error making API call: $error');
    }
    homeController.loading.value = false;
  }
}